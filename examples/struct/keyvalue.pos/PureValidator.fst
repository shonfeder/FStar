module PureValidator

open KeyValue
open PureParser

open FStar.Seq
module U16 = FStar.UInt16
module U32 = FStar.UInt32

(*! Pure validation *)

let validator = parser unit
// let parse_validator #t (p:parser t) = b:bytes -> (ok:bool{ok <==> Some? (p b)} * n:nat{n <= length b})

let seq (#t:Type) (#t':Type) (p:parser t) (p': parser t') : parser t' =
  fun b -> match p b with
        | Some (_, l) -> begin
                match p' (slice b l (length b)) with
                | Some (v, l') -> Some (v, l + l')
                | None -> None
          end
        | None -> None

unfold let invalid (#b:bytes): option (unit * n:nat{n <= length b}) = None
unfold let valid (#b:bytes) (n:nat{n <= length b}) : option (unit * n:nat{n <= length b}) = Some ((), n)

let skip_bytes (n:nat) : validator =
  fun b -> if length b < n then invalid
        else valid n

// this is analogous to the stateful version, validation_check_parse, but pure
// validators are a special case of parsers and don't return quite the same
// thing
let parser_validation_checks_parse #t (b: bytes)
  (v: option (unit * n:nat{n <= length b}))
  (p: option (t * n:nat{n <= length b})) : Type0 =
  Some? v ==> (Some? p /\ snd (Some?.v v) == snd (Some?.v p))

let validator_checks_on (v:validator) #t (p: parser t) (b:bytes) = parser_validation_checks_parse b (v b) (p b)

// NOTE: this proof about the whole validator works better than a function with
// built-in correctness proof (despite the universal quantifier)
(** a correctness condition for a validator, stating that it correctly reports
    when a parser will succeed (the implication only needs to be validated ==>
    will parse, but this has worked so far) *)
let validator_checks (v:validator) #t (p: parser t) = forall b. validator_checks_on v p b

// this definitions assists type inference by forcing t'=unit; it also makes the
// code read a bit better
let then_validate (#t:Type) (p:parser t) (v:t -> validator) : validator =
    and_then p v

val validate_u16_array: v:validator{validator_checks v parse_u16_array}
let validate_u16_array =
  parse_u16 `then_validate`
  (fun array_len -> skip_bytes (U16.v array_len))

val validate_u32_array: v:validator{validator_checks v parse_u32_array}
let validate_u32_array =
  parse_u32 `then_validate`
  (fun array_len -> skip_bytes (U32.v array_len))

let validate_entry: v:validator{validator_checks v parse_entry} =
  validate_u16_array `seq`
  validate_u32_array

unfold let validate_accept : validator =
  fun b -> valid 0
unfold let validate_reject : validator =
  fun b -> invalid

val validate_many':
  n:nat ->
  v:validator ->
  v':validator
let rec validate_many' n v =
  match n with
  | 0 -> validate_accept
  | _ -> v `seq` validate_many' (n-1) v

let validate_seq (#t:Type) (#t':Type)
  (p: parser t) (p': parser t')
  (v: validator{validator_checks v p})
  (v': validator{validator_checks v' p'}) :
  Lemma (validator_checks (v `seq` v') (p `seq` p')) = ()

#set-options "--max_fuel 0 --z3rlimit 50"

val validate_liftA2 (#t:Type) (#t':Type) (#t'':Type)
  (p: parser t) (p': parser t') (f: t -> t' -> t'')
  (v: validator{validator_checks v p})
  (v': validator{validator_checks v' p'}) :
  Lemma (validator_checks (v `seq` v') (p `and_then` (fun (x:t) -> p' `and_then` (fun (y:t') -> parse_ret (f x y)))))
let validate_liftA2 #t #t' #t'' p p' f v v' =
  assert (forall x. validator_checks v' (p' `and_then` (fun y -> parse_ret (f x y))));
  assert (forall b. match v b with
               | Some (_, l) -> Some? (p b) /\ snd (Some?.v (p b)) == l
               | None -> true);
  ()

#reset-options

let rec validate_many'_ok (n:nat) (#t:Type) (p: parser t) (v:validator{validator_checks v p}) :
  Lemma (validator_checks (validate_many' n v) (parse_many' p n)) =
  match n with
  | 0 -> ()
  | _ -> validate_many'_ok (n-1) p v;
        let p' = parse_many' p (n-1) in
        let v': v:validator{validator_checks v p'} = validate_many' (n-1) v in
        validate_liftA2 p p' (fun v l -> v::l) v v';
        ()

val validate_many:
  #t:Type -> p:parser t ->
  n:nat ->
  v:validator{validator_checks v p} ->
  v':validator{validator_checks v' (parse_many p n)}
let validate_many #t p n v = validate_many'_ok n p v; validate_many' n v

let validate_done : v:validator{validator_checks v parsing_done} =
  fun b -> if length b = 0 then valid 0
        else invalid

// TODO: tie together pieces to prove this overall correctness result
val validate: v:validator{validator_checks v parse_abstract_store}
let validate =
  admit();
  parse_u32 `then_validate`
  (fun num_entries -> validate_many parse_entry (U32.v num_entries) validate_entry `seq`
                   validate_done)
