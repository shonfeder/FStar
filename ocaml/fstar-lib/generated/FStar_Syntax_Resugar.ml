open Prims
let (doc_to_string : FStar_Pprint.document -> Prims.string) =
  fun doc ->
    FStar_Pprint.pretty_string (FStar_Compiler_Util.float_of_string "1.0")
      (Prims.of_int (100)) doc
let (parser_term_to_string : FStar_Parser_AST.term -> Prims.string) =
  fun t ->
    let uu___ = FStar_Parser_ToDocument.term_to_document t in
    doc_to_string uu___
let (parser_pat_to_string : FStar_Parser_AST.pattern -> Prims.string) =
  fun t ->
    let uu___ = FStar_Parser_ToDocument.pat_to_document t in
    doc_to_string uu___
let (tts : FStar_Syntax_Syntax.term -> Prims.string) =
  fun t -> FStar_Syntax_Util.tts t
let map_opt :
  'uuuuu 'uuuuu1 .
    unit ->
      ('uuuuu -> 'uuuuu1 FStar_Pervasives_Native.option) ->
        'uuuuu Prims.list -> 'uuuuu1 Prims.list
  = fun uu___ -> FStar_Compiler_List.filter_map
let (bv_as_unique_ident : FStar_Syntax_Syntax.bv -> FStar_Ident.ident) =
  fun x ->
    let unique_name =
      let uu___ =
        (let uu___1 = FStar_Ident.string_of_id x.FStar_Syntax_Syntax.ppname in
         FStar_Compiler_Util.starts_with FStar_Ident.reserved_prefix uu___1)
          || (FStar_Options.print_real_names ()) in
      if uu___
      then
        let uu___1 = FStar_Ident.string_of_id x.FStar_Syntax_Syntax.ppname in
        let uu___2 =
          FStar_Compiler_Util.string_of_int x.FStar_Syntax_Syntax.index in
        Prims.strcat uu___1 uu___2
      else FStar_Ident.string_of_id x.FStar_Syntax_Syntax.ppname in
    let uu___ =
      let uu___1 = FStar_Ident.range_of_id x.FStar_Syntax_Syntax.ppname in
      (unique_name, uu___1) in
    FStar_Ident.mk_ident uu___
let (filter_imp :
  FStar_Syntax_Syntax.binder_qualifier FStar_Pervasives_Native.option ->
    Prims.bool)
  =
  fun a ->
    match a with
    | FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Meta t) when
        FStar_Syntax_Util.is_fvar FStar_Parser_Const.tcresolve_lid t -> true
    | FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Implicit uu___) ->
        false
    | FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Meta uu___) -> false
    | uu___ -> true
let (filter_imp_args : FStar_Syntax_Syntax.args -> FStar_Syntax_Syntax.args)
  =
  fun args ->
    FStar_Compiler_List.filter
      (fun uu___ ->
         match uu___ with
         | (uu___1, FStar_Pervasives_Native.None) -> true
         | (uu___1, FStar_Pervasives_Native.Some arg) ->
             Prims.op_Negation arg.FStar_Syntax_Syntax.aqual_implicit) args
let (filter_imp_bs :
  FStar_Syntax_Syntax.binder Prims.list ->
    FStar_Syntax_Syntax.binder Prims.list)
  =
  fun bs ->
    FStar_Compiler_List.filter
      (fun b -> filter_imp b.FStar_Syntax_Syntax.binder_qual) bs
let filter_pattern_imp :
  'uuuuu .
    ('uuuuu * Prims.bool) Prims.list -> ('uuuuu * Prims.bool) Prims.list
  =
  fun xs ->
    FStar_Compiler_List.filter
      (fun uu___ ->
         match uu___ with
         | (uu___1, is_implicit) -> Prims.op_Negation is_implicit) xs
let (label : Prims.string -> FStar_Parser_AST.term -> FStar_Parser_AST.term)
  =
  fun s ->
    fun t ->
      if s = ""
      then t
      else
        FStar_Parser_AST.mk_term (FStar_Parser_AST.Labeled (t, s, true))
          t.FStar_Parser_AST.range FStar_Parser_AST.Un
let rec (universe_to_int :
  Prims.int ->
    FStar_Syntax_Syntax.universe ->
      (Prims.int * FStar_Syntax_Syntax.universe))
  =
  fun n ->
    fun u ->
      let uu___ = FStar_Syntax_Subst.compress_univ u in
      match uu___ with
      | FStar_Syntax_Syntax.U_succ u1 ->
          universe_to_int (n + Prims.int_one) u1
      | uu___1 -> (n, u)
let (universe_to_string : FStar_Ident.ident Prims.list -> Prims.string) =
  fun univs ->
    let uu___ = FStar_Options.print_universes () in
    if uu___
    then
      let uu___1 =
        FStar_Compiler_List.map (fun x -> FStar_Ident.string_of_id x) univs in
      FStar_Compiler_String.concat ", " uu___1
    else ""
let rec (resugar_universe :
  FStar_Syntax_Syntax.universe ->
    FStar_Compiler_Range_Type.range -> FStar_Parser_AST.term)
  =
  fun u ->
    fun r ->
      let mk a r1 = FStar_Parser_AST.mk_term a r1 FStar_Parser_AST.Un in
      let u1 = FStar_Syntax_Subst.compress_univ u in
      match u1 with
      | FStar_Syntax_Syntax.U_zero ->
          mk
            (FStar_Parser_AST.Const
               (FStar_Const.Const_int ("0", FStar_Pervasives_Native.None))) r
      | FStar_Syntax_Syntax.U_succ uu___ ->
          let uu___1 = universe_to_int Prims.int_zero u1 in
          (match uu___1 with
           | (n, u2) ->
               (match u2 with
                | FStar_Syntax_Syntax.U_zero ->
                    let uu___2 =
                      let uu___3 =
                        let uu___4 =
                          let uu___5 = FStar_Compiler_Util.string_of_int n in
                          (uu___5, FStar_Pervasives_Native.None) in
                        FStar_Const.Const_int uu___4 in
                      FStar_Parser_AST.Const uu___3 in
                    mk uu___2 r
                | uu___2 ->
                    let e1 =
                      let uu___3 =
                        let uu___4 =
                          let uu___5 =
                            let uu___6 = FStar_Compiler_Util.string_of_int n in
                            (uu___6, FStar_Pervasives_Native.None) in
                          FStar_Const.Const_int uu___5 in
                        FStar_Parser_AST.Const uu___4 in
                      mk uu___3 r in
                    let e2 = resugar_universe u2 r in
                    let uu___3 =
                      let uu___4 =
                        let uu___5 = FStar_Ident.id_of_text "+" in
                        (uu___5, [e1; e2]) in
                      FStar_Parser_AST.Op uu___4 in
                    mk uu___3 r))
      | FStar_Syntax_Syntax.U_max l ->
          (match l with
           | [] ->
               FStar_Compiler_Effect.failwith
                 "Impossible: U_max without arguments"
           | uu___ ->
               let t =
                 let uu___1 =
                   let uu___2 = FStar_Ident.lid_of_path ["max"] r in
                   FStar_Parser_AST.Var uu___2 in
                 mk uu___1 r in
               FStar_Compiler_List.fold_left
                 (fun acc ->
                    fun x ->
                      let uu___1 =
                        let uu___2 =
                          let uu___3 = resugar_universe x r in
                          (acc, uu___3, FStar_Parser_AST.Nothing) in
                        FStar_Parser_AST.App uu___2 in
                      mk uu___1 r) t l)
      | FStar_Syntax_Syntax.U_name u2 -> mk (FStar_Parser_AST.Uvar u2) r
      | FStar_Syntax_Syntax.U_unif uu___ -> mk FStar_Parser_AST.Wild r
      | FStar_Syntax_Syntax.U_bvar x ->
          let id =
            let uu___ =
              let uu___1 =
                let uu___2 = FStar_Compiler_Util.string_of_int x in
                FStar_Compiler_Util.strcat "uu__univ_bvar_" uu___2 in
              (uu___1, r) in
            FStar_Ident.mk_ident uu___ in
          mk (FStar_Parser_AST.Uvar id) r
      | FStar_Syntax_Syntax.U_unknown -> mk FStar_Parser_AST.Wild r
let (resugar_universe' :
  FStar_Syntax_DsEnv.env ->
    FStar_Syntax_Syntax.universe ->
      FStar_Compiler_Range_Type.range -> FStar_Parser_AST.term)
  = fun env -> fun u -> fun r -> resugar_universe u r
type expected_arity = Prims.int FStar_Pervasives_Native.option
let rec (resugar_term_as_op :
  FStar_Syntax_Syntax.term ->
    (Prims.string * expected_arity) FStar_Pervasives_Native.option)
  =
  fun t ->
    let infix_prim_ops =
      [(FStar_Parser_Const.op_Addition, "+");
      (FStar_Parser_Const.op_Subtraction, "-");
      (FStar_Parser_Const.op_Minus, "-");
      (FStar_Parser_Const.op_Multiply, "*");
      (FStar_Parser_Const.op_Division, "/");
      (FStar_Parser_Const.op_Modulus, "%");
      (FStar_Parser_Const.read_lid, "!");
      (FStar_Parser_Const.list_append_lid, "@");
      (FStar_Parser_Const.list_tot_append_lid, "@");
      (FStar_Parser_Const.op_Eq, "=");
      (FStar_Parser_Const.op_ColonEq, ":=");
      (FStar_Parser_Const.op_notEq, "<>");
      (FStar_Parser_Const.not_lid, "~");
      (FStar_Parser_Const.op_And, "&&");
      (FStar_Parser_Const.op_Or, "||");
      (FStar_Parser_Const.op_LTE, "<=");
      (FStar_Parser_Const.op_GTE, ">=");
      (FStar_Parser_Const.op_LT, "<");
      (FStar_Parser_Const.op_GT, ">");
      (FStar_Parser_Const.op_Modulus, "mod");
      (FStar_Parser_Const.and_lid, "/\\");
      (FStar_Parser_Const.or_lid, "\\/");
      (FStar_Parser_Const.imp_lid, "==>");
      (FStar_Parser_Const.iff_lid, "<==>");
      (FStar_Parser_Const.precedes_lid, "<<");
      (FStar_Parser_Const.eq2_lid, "==");
      (FStar_Parser_Const.forall_lid, "forall");
      (FStar_Parser_Const.exists_lid, "exists");
      (FStar_Parser_Const.salloc_lid, "alloc");
      (FStar_Parser_Const.calc_finish_lid, "calc_finish")] in
    let fallback fv =
      let uu___ =
        FStar_Compiler_Util.find_opt
          (fun d ->
             FStar_Syntax_Syntax.fv_eq_lid fv (FStar_Pervasives_Native.fst d))
          infix_prim_ops in
      match uu___ with
      | FStar_Pervasives_Native.Some op ->
          FStar_Pervasives_Native.Some
            ((FStar_Pervasives_Native.snd op), FStar_Pervasives_Native.None)
      | uu___1 ->
          let length =
            let uu___2 =
              FStar_Ident.nsstr
                (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
            FStar_Compiler_String.length uu___2 in
          let str =
            if length = Prims.int_zero
            then
              FStar_Ident.string_of_lid
                (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
            else
              (let uu___3 =
                 FStar_Ident.string_of_lid
                   (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
               FStar_Compiler_Util.substring_from uu___3
                 (length + Prims.int_one)) in
          let uu___2 =
            (FStar_Compiler_Util.starts_with str "dtuple") &&
              (let uu___3 =
                 let uu___4 =
                   FStar_Compiler_Util.substring_from str (Prims.of_int (6)) in
                 FStar_Compiler_Util.safe_int_of_string uu___4 in
               FStar_Compiler_Option.isSome uu___3) in
          if uu___2
          then
            let uu___3 =
              let uu___4 =
                let uu___5 =
                  FStar_Compiler_Util.substring_from str (Prims.of_int (6)) in
                FStar_Compiler_Util.safe_int_of_string uu___5 in
              ("dtuple", uu___4) in
            FStar_Pervasives_Native.Some uu___3
          else
            (let uu___4 =
               (FStar_Compiler_Util.starts_with str "tuple") &&
                 (let uu___5 =
                    let uu___6 =
                      FStar_Compiler_Util.substring_from str
                        (Prims.of_int (5)) in
                    FStar_Compiler_Util.safe_int_of_string uu___6 in
                  FStar_Compiler_Option.isSome uu___5) in
             if uu___4
             then
               let uu___5 =
                 let uu___6 =
                   let uu___7 =
                     FStar_Compiler_Util.substring_from str
                       (Prims.of_int (5)) in
                   FStar_Compiler_Util.safe_int_of_string uu___7 in
                 ("tuple", uu___6) in
               FStar_Pervasives_Native.Some uu___5
             else
               if FStar_Compiler_Util.starts_with str "try_with"
               then
                 FStar_Pervasives_Native.Some
                   ("try_with", FStar_Pervasives_Native.None)
               else
                 (let uu___7 =
                    FStar_Syntax_Syntax.fv_eq_lid fv
                      FStar_Parser_Const.sread_lid in
                  if uu___7
                  then
                    let uu___8 =
                      let uu___9 =
                        FStar_Ident.string_of_lid
                          (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
                      (uu___9, FStar_Pervasives_Native.None) in
                    FStar_Pervasives_Native.Some uu___8
                  else FStar_Pervasives_Native.None)) in
    let uu___ =
      let uu___1 = FStar_Syntax_Subst.compress t in
      uu___1.FStar_Syntax_Syntax.n in
    match uu___ with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        let length =
          let uu___1 =
            FStar_Ident.nsstr
              (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
          FStar_Compiler_String.length uu___1 in
        let s =
          if length = Prims.int_zero
          then
            FStar_Ident.string_of_lid
              (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
          else
            (let uu___2 =
               FStar_Ident.string_of_lid
                 (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
             FStar_Compiler_Util.substring_from uu___2
               (length + Prims.int_one)) in
        let uu___1 = FStar_Parser_AST.string_to_op s in
        (match uu___1 with
         | FStar_Pervasives_Native.Some t1 -> FStar_Pervasives_Native.Some t1
         | uu___2 -> fallback fv)
    | FStar_Syntax_Syntax.Tm_uinst (e, us) -> resugar_term_as_op e
    | uu___1 -> FStar_Pervasives_Native.None
let (is_true_pat : FStar_Syntax_Syntax.pat -> Prims.bool) =
  fun p ->
    match p.FStar_Syntax_Syntax.v with
    | FStar_Syntax_Syntax.Pat_constant (FStar_Const.Const_bool (true)) ->
        true
    | uu___ -> false
let (is_tuple_constructor_lid : FStar_Ident.lident -> Prims.bool) =
  fun lid ->
    (FStar_Parser_Const.is_tuple_data_lid' lid) ||
      (FStar_Parser_Const.is_dtuple_data_lid' lid)
let (may_shorten : FStar_Ident.lident -> Prims.bool) =
  fun lid ->
    let uu___ = FStar_Options.print_real_names () in
    if uu___
    then false
    else
      (let uu___2 = FStar_Ident.string_of_lid lid in
       match uu___2 with
       | "Prims.Nil" -> false
       | "Prims.Cons" -> false
       | uu___3 ->
           let uu___4 = is_tuple_constructor_lid lid in
           Prims.op_Negation uu___4)
let (maybe_shorten_lid :
  FStar_Syntax_DsEnv.env -> FStar_Ident.lident -> FStar_Ident.lident) =
  fun env ->
    fun lid ->
      let uu___ = may_shorten lid in
      if uu___ then FStar_Syntax_DsEnv.shorten_lid env lid else lid
let (maybe_shorten_fv :
  FStar_Syntax_DsEnv.env -> FStar_Syntax_Syntax.fv -> FStar_Ident.lident) =
  fun env ->
    fun fv ->
      let lid = (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
      maybe_shorten_lid env lid
let (serialize_machine_integer_desc :
  (FStar_Const.signedness * FStar_Const.width) -> Prims.string Prims.list) =
  fun uu___ ->
    match uu___ with
    | (s, w) ->
        let sU =
          match s with
          | FStar_Const.Unsigned -> "U"
          | FStar_Const.Signed -> "" in
        let sW =
          match w with
          | FStar_Const.Int8 -> "8"
          | FStar_Const.Int16 -> "16"
          | FStar_Const.Int32 -> "32"
          | FStar_Const.Int64 -> "64" in
        let su =
          match s with
          | FStar_Const.Unsigned -> "u"
          | FStar_Const.Signed -> "" in
        let uu___1 =
          FStar_Compiler_Util.format3 "FStar.%sInt%s.__%sint_to_t" sU sW su in
        let uu___2 =
          let uu___3 =
            FStar_Compiler_Util.format3 "FStar.%sInt%s.%sint_to_t" sU sW su in
          [uu___3] in
        uu___1 :: uu___2
let (parse_machine_integer_desc :
  FStar_Syntax_Syntax.fv ->
    ((FStar_Const.signedness * FStar_Const.width) * Prims.string)
      FStar_Pervasives_Native.option)
  =
  let signs = [FStar_Const.Unsigned; FStar_Const.Signed] in
  let widths =
    [FStar_Const.Int8;
    FStar_Const.Int16;
    FStar_Const.Int32;
    FStar_Const.Int64] in
  let descs =
    let uu___ =
      Obj.magic
        (FStar_Class_Monad.op_let_Bang FStar_Class_Monad.monad_list () ()
           (Obj.magic signs)
           (fun uu___1 ->
              (fun s ->
                 let s = Obj.magic s in
                 Obj.magic
                   (FStar_Class_Monad.op_let_Bang
                      FStar_Class_Monad.monad_list () () (Obj.magic widths)
                      (fun uu___1 ->
                         (fun w ->
                            let w = Obj.magic w in
                            let uu___1 =
                              serialize_machine_integer_desc (s, w) in
                            Obj.magic
                              (FStar_Class_Monad.op_let_Bang
                                 FStar_Class_Monad.monad_list () ()
                                 (Obj.magic uu___1)
                                 (fun uu___2 ->
                                    (fun desc ->
                                       let desc = Obj.magic desc in
                                       Obj.magic [((s, w), desc)]) uu___2)))
                           uu___1))) uu___1)) in
    ((FStar_Const.Unsigned, FStar_Const.Sizet), "FStar.SizeT.__uint_to_t") ::
      uu___ in
  fun fv ->
    FStar_Compiler_List.tryFind
      (fun uu___ ->
         match uu___ with
         | (uu___1, d) ->
             let uu___2 =
               let uu___3 = FStar_Syntax_Syntax.lid_of_fv fv in
               FStar_Ident.string_of_lid uu___3 in
             d = uu___2) descs
let (can_resugar_machine_integer : FStar_Syntax_Syntax.fv -> Prims.bool) =
  fun fv ->
    let uu___ = parse_machine_integer_desc fv in
    FStar_Compiler_Option.isSome uu___
let (resugar_machine_integer :
  FStar_Syntax_Syntax.fv ->
    Prims.string -> FStar_Compiler_Range_Type.range -> FStar_Parser_AST.term)
  =
  fun fv ->
    fun i ->
      fun pos ->
        let uu___ = parse_machine_integer_desc fv in
        match uu___ with
        | FStar_Pervasives_Native.None ->
            FStar_Compiler_Effect.failwith
              "Impossible: should be guarded by can_resugar_machine_integer"
        | FStar_Pervasives_Native.Some (sw, uu___1) ->
            FStar_Parser_AST.mk_term
              (FStar_Parser_AST.Const
                 (FStar_Const.Const_int
                    (i, (FStar_Pervasives_Native.Some sw)))) pos
              FStar_Parser_AST.Un
let rec (__is_list_literal :
  FStar_Ident.lident ->
    FStar_Ident.lident ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term Prims.list FStar_Pervasives_Native.option)
  =
  fun uu___2 ->
    fun uu___1 ->
      fun uu___ ->
        (fun cons_lid ->
           fun nil_lid ->
             fun t ->
               let uu___ = FStar_Syntax_Util.head_and_args_full t in
               match uu___ with
               | (hd, args) ->
                   let hd1 =
                     let uu___1 = FStar_Syntax_Util.un_uinst hd in
                     FStar_Syntax_Subst.compress uu___1 in
                   let args1 =
                     let uu___1 = FStar_Options.print_implicits () in
                     if uu___1 then args else filter_imp_args args in
                   (match ((hd1.FStar_Syntax_Syntax.n), args1) with
                    | (FStar_Syntax_Syntax.Tm_fvar fv,
                       (hd2, FStar_Pervasives_Native.None)::(tl,
                                                             FStar_Pervasives_Native.None)::[])
                        when FStar_Syntax_Syntax.fv_eq_lid fv cons_lid ->
                        Obj.magic
                          (Obj.repr
                             (let uu___1 =
                                __is_list_literal cons_lid nil_lid tl in
                              FStar_Class_Monad.op_let_Bang
                                FStar_Class_Monad.monad_option () ()
                                (Obj.magic uu___1)
                                (fun uu___2 ->
                                   (fun tl1 ->
                                      let tl1 = Obj.magic tl1 in
                                      Obj.magic
                                        (FStar_Class_Monad.return
                                           FStar_Class_Monad.monad_option ()
                                           (Obj.magic (hd2 :: tl1)))) uu___2)))
                    | (FStar_Syntax_Syntax.Tm_fvar fv, []) when
                        FStar_Syntax_Syntax.fv_eq_lid fv nil_lid ->
                        Obj.magic
                          (Obj.repr
                             (FStar_Class_Monad.return
                                FStar_Class_Monad.monad_option ()
                                (Obj.magic [])))
                    | (uu___1, uu___2) ->
                        Obj.magic (Obj.repr FStar_Pervasives_Native.None)))
          uu___2 uu___1 uu___
let (is_list_literal :
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term Prims.list FStar_Pervasives_Native.option)
  = __is_list_literal FStar_Parser_Const.cons_lid FStar_Parser_Const.nil_lid
let (is_seq_literal :
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term Prims.list FStar_Pervasives_Native.option)
  =
  __is_list_literal FStar_Parser_Const.seq_cons_lid
    FStar_Parser_Const.seq_empty_lid
let rec (resugar_term' :
  FStar_Syntax_DsEnv.env -> FStar_Syntax_Syntax.term -> FStar_Parser_AST.term)
  =
  fun env ->
    fun t ->
      let mk a =
        FStar_Parser_AST.mk_term a t.FStar_Syntax_Syntax.pos
          FStar_Parser_AST.Un in
      let name a r =
        let uu___ = FStar_Ident.lid_of_path [a] r in
        FStar_Parser_AST.Name uu___ in
      let uu___ =
        let uu___1 = FStar_Syntax_Subst.compress t in
        uu___1.FStar_Syntax_Syntax.n in
      match uu___ with
      | FStar_Syntax_Syntax.Tm_delayed uu___1 ->
          FStar_Compiler_Effect.failwith
            "Tm_delayed is impossible after compress"
      | FStar_Syntax_Syntax.Tm_lazy i ->
          let uu___1 = FStar_Syntax_Util.unfold_lazy i in
          resugar_term' env uu___1
      | FStar_Syntax_Syntax.Tm_bvar x ->
          let l =
            let uu___1 = let uu___2 = bv_as_unique_ident x in [uu___2] in
            FStar_Ident.lid_of_ids uu___1 in
          mk (FStar_Parser_AST.Var l)
      | FStar_Syntax_Syntax.Tm_name x ->
          let l =
            let uu___1 = let uu___2 = bv_as_unique_ident x in [uu___2] in
            FStar_Ident.lid_of_ids uu___1 in
          mk (FStar_Parser_AST.Var l)
      | FStar_Syntax_Syntax.Tm_fvar fv ->
          let a = (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
          let length =
            let uu___1 =
              FStar_Ident.nsstr
                (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
            FStar_Compiler_String.length uu___1 in
          let s =
            if length = Prims.int_zero
            then FStar_Ident.string_of_lid a
            else
              (let uu___2 = FStar_Ident.string_of_lid a in
               FStar_Compiler_Util.substring_from uu___2
                 (length + Prims.int_one)) in
          let is_prefix = Prims.strcat FStar_Ident.reserved_prefix "is_" in
          if FStar_Compiler_Util.starts_with s is_prefix
          then
            let rest =
              FStar_Compiler_Util.substring_from s
                (FStar_Compiler_String.length is_prefix) in
            let uu___1 =
              let uu___2 =
                FStar_Ident.lid_of_path [rest] t.FStar_Syntax_Syntax.pos in
              FStar_Parser_AST.Discrim uu___2 in
            mk uu___1
          else
            if
              FStar_Compiler_Util.starts_with s
                FStar_Syntax_Util.field_projector_prefix
            then
              (let rest =
                 FStar_Compiler_Util.substring_from s
                   (FStar_Compiler_String.length
                      FStar_Syntax_Util.field_projector_prefix) in
               let r =
                 FStar_Compiler_Util.split rest
                   FStar_Syntax_Util.field_projector_sep in
               match r with
               | fst::snd::[] ->
                   let l =
                     FStar_Ident.lid_of_path [fst] t.FStar_Syntax_Syntax.pos in
                   let r1 =
                     FStar_Ident.mk_ident (snd, (t.FStar_Syntax_Syntax.pos)) in
                   mk (FStar_Parser_AST.Projector (l, r1))
               | uu___2 ->
                   FStar_Compiler_Effect.failwith "wrong projector format")
            else
              (let uu___3 =
                 FStar_Ident.lid_equals a FStar_Parser_Const.smtpat_lid in
               if uu___3
               then
                 let uu___4 =
                   let uu___5 =
                     let uu___6 =
                       let uu___7 = FStar_Ident.range_of_lid a in
                       ("SMTPat", uu___7) in
                     FStar_Ident.mk_ident uu___6 in
                   FStar_Parser_AST.Tvar uu___5 in
                 mk uu___4
               else
                 (let uu___5 =
                    FStar_Ident.lid_equals a FStar_Parser_Const.smtpatOr_lid in
                  if uu___5
                  then
                    let uu___6 =
                      let uu___7 =
                        let uu___8 =
                          let uu___9 = FStar_Ident.range_of_lid a in
                          ("SMTPatOr", uu___9) in
                        FStar_Ident.mk_ident uu___8 in
                      FStar_Parser_AST.Tvar uu___7 in
                    mk uu___6
                  else
                    (let uu___7 =
                       ((FStar_Ident.lid_equals a
                           FStar_Parser_Const.assert_lid)
                          ||
                          (FStar_Ident.lid_equals a
                             FStar_Parser_Const.assume_lid))
                         ||
                         (let uu___8 =
                            let uu___9 =
                              FStar_Compiler_String.get s Prims.int_zero in
                            FStar_Char.uppercase uu___9 in
                          let uu___9 =
                            FStar_Compiler_String.get s Prims.int_zero in
                          uu___8 <> uu___9) in
                     if uu___7
                     then
                       let uu___8 =
                         let uu___9 = maybe_shorten_fv env fv in
                         FStar_Parser_AST.Var uu___9 in
                       mk uu___8
                     else
                       (let uu___9 =
                          let uu___10 =
                            let uu___11 = maybe_shorten_fv env fv in
                            (uu___11, []) in
                          FStar_Parser_AST.Construct uu___10 in
                        mk uu___9))))
      | FStar_Syntax_Syntax.Tm_uinst (e, universes) ->
          let e1 = resugar_term' env e in
          let uu___1 = FStar_Options.print_universes () in
          if uu___1
          then
            let univs =
              FStar_Compiler_List.map
                (fun x -> resugar_universe x t.FStar_Syntax_Syntax.pos)
                universes in
            (match e1 with
             | { FStar_Parser_AST.tm = FStar_Parser_AST.Construct (hd, args);
                 FStar_Parser_AST.range = r; FStar_Parser_AST.level = l;_} ->
                 let args1 =
                   let uu___2 =
                     FStar_Compiler_List.map
                       (fun u -> (u, FStar_Parser_AST.UnivApp)) univs in
                   FStar_Compiler_List.op_At args uu___2 in
                 FStar_Parser_AST.mk_term
                   (FStar_Parser_AST.Construct (hd, args1)) r l
             | uu___2 ->
                 FStar_Compiler_List.fold_left
                   (fun acc ->
                      fun u ->
                        mk
                          (FStar_Parser_AST.App
                             (acc, u, FStar_Parser_AST.UnivApp))) e1 univs)
          else e1
      | FStar_Syntax_Syntax.Tm_constant c ->
          let uu___1 = FStar_Syntax_Syntax.is_teff t in
          if uu___1
          then
            let uu___2 = name "Effect" t.FStar_Syntax_Syntax.pos in mk uu___2
          else mk (FStar_Parser_AST.Const c)
      | FStar_Syntax_Syntax.Tm_type u ->
          let uu___1 =
            match u with
            | FStar_Syntax_Syntax.U_zero -> ("Type0", false)
            | FStar_Syntax_Syntax.U_unknown -> ("Type", false)
            | uu___2 -> ("Type", true) in
          (match uu___1 with
           | (nm, needs_app) ->
               let typ =
                 let uu___2 = name nm t.FStar_Syntax_Syntax.pos in mk uu___2 in
               let uu___2 = needs_app && (FStar_Options.print_universes ()) in
               if uu___2
               then
                 let uu___3 =
                   let uu___4 =
                     let uu___5 =
                       resugar_universe u t.FStar_Syntax_Syntax.pos in
                     (typ, uu___5, FStar_Parser_AST.UnivApp) in
                   FStar_Parser_AST.App uu___4 in
                 mk uu___3
               else typ)
      | FStar_Syntax_Syntax.Tm_abs
          { FStar_Syntax_Syntax.bs = xs; FStar_Syntax_Syntax.body = body;
            FStar_Syntax_Syntax.rc_opt = uu___1;_}
          ->
          let uu___2 = FStar_Syntax_Subst.open_term xs body in
          (match uu___2 with
           | (xs1, body1) ->
               let xs2 =
                 let uu___3 = FStar_Options.print_implicits () in
                 if uu___3
                 then xs1
                 else
                   FStar_Compiler_List.filter
                     (fun x -> filter_imp x.FStar_Syntax_Syntax.binder_qual)
                     xs1 in
               let body_bv = FStar_Syntax_Free.names body1 in
               let patterns =
                 FStar_Compiler_List.choose
                   (fun x ->
                      resugar_bv_as_pat env x.FStar_Syntax_Syntax.binder_bv
                        x.FStar_Syntax_Syntax.binder_qual body_bv) xs2 in
               let body2 = resugar_term' env body1 in
               if FStar_Compiler_List.isEmpty patterns
               then body2
               else mk (FStar_Parser_AST.Abs (patterns, body2)))
      | FStar_Syntax_Syntax.Tm_arrow uu___1 ->
          let uu___2 =
            let uu___3 =
              let uu___4 =
                let uu___5 = FStar_Syntax_Util.canon_arrow t in
                FStar_Syntax_Subst.compress uu___5 in
              uu___4.FStar_Syntax_Syntax.n in
            match uu___3 with
            | FStar_Syntax_Syntax.Tm_arrow
                { FStar_Syntax_Syntax.bs1 = xs;
                  FStar_Syntax_Syntax.comp = body;_}
                -> (xs, body)
            | uu___4 ->
                FStar_Compiler_Effect.failwith
                  "impossible: Tm_arrow in resugar_term" in
          (match uu___2 with
           | (xs, body) ->
               let uu___3 = FStar_Syntax_Subst.open_comp xs body in
               (match uu___3 with
                | (xs1, body1) ->
                    let xs2 =
                      let uu___4 = FStar_Options.print_implicits () in
                      if uu___4 then xs1 else filter_imp_bs xs1 in
                    let body2 = resugar_comp' env body1 in
                    let xs3 =
                      let uu___4 =
                        (map_opt ())
                          (fun b ->
                             resugar_binder' env b t.FStar_Syntax_Syntax.pos)
                          xs2 in
                      FStar_Compiler_List.rev uu___4 in
                    let rec aux body3 uu___4 =
                      match uu___4 with
                      | [] -> body3
                      | hd::tl ->
                          let body4 =
                            mk (FStar_Parser_AST.Product ([hd], body3)) in
                          aux body4 tl in
                    aux body2 xs3))
      | FStar_Syntax_Syntax.Tm_refine
          { FStar_Syntax_Syntax.b = x; FStar_Syntax_Syntax.phi = phi;_} ->
          let uu___1 =
            let uu___2 =
              let uu___3 = FStar_Syntax_Syntax.mk_binder x in [uu___3] in
            FStar_Syntax_Subst.open_term uu___2 phi in
          (match uu___1 with
           | (x1, phi1) ->
               let b =
                 let uu___2 =
                   let uu___3 = FStar_Compiler_List.hd x1 in
                   resugar_binder' env uu___3 t.FStar_Syntax_Syntax.pos in
                 FStar_Compiler_Util.must uu___2 in
               let uu___2 =
                 let uu___3 =
                   let uu___4 = resugar_term' env phi1 in (b, uu___4) in
                 FStar_Parser_AST.Refine uu___3 in
               mk uu___2)
      | FStar_Syntax_Syntax.Tm_app
          {
            FStar_Syntax_Syntax.hd =
              { FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar fv;
                FStar_Syntax_Syntax.pos = uu___1;
                FStar_Syntax_Syntax.vars = uu___2;
                FStar_Syntax_Syntax.hash_code = uu___3;_};
            FStar_Syntax_Syntax.args = (e, uu___4)::[];_}
          when
          (let uu___5 = FStar_Options.print_implicits () in
           Prims.op_Negation uu___5) &&
            (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.b2t_lid)
          -> resugar_term' env e
      | FStar_Syntax_Syntax.Tm_app
          {
            FStar_Syntax_Syntax.hd =
              { FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar fv;
                FStar_Syntax_Syntax.pos = uu___1;
                FStar_Syntax_Syntax.vars = uu___2;
                FStar_Syntax_Syntax.hash_code = uu___3;_};
            FStar_Syntax_Syntax.args =
              ({
                 FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_constant
                   (FStar_Const.Const_int (i, FStar_Pervasives_Native.None));
                 FStar_Syntax_Syntax.pos = uu___4;
                 FStar_Syntax_Syntax.vars = uu___5;
                 FStar_Syntax_Syntax.hash_code = uu___6;_},
               uu___7)::[];_}
          when can_resugar_machine_integer fv ->
          resugar_machine_integer fv i t.FStar_Syntax_Syntax.pos
      | FStar_Syntax_Syntax.Tm_app uu___1 ->
          let t1 = FStar_Syntax_Util.canon_app t in
          let uu___2 = t1.FStar_Syntax_Syntax.n in
          (match uu___2 with
           | FStar_Syntax_Syntax.Tm_app
               { FStar_Syntax_Syntax.hd = e;
                 FStar_Syntax_Syntax.args = args;_}
               ->
               let rec last uu___3 =
                 match uu___3 with
                 | hd::[] -> [hd]
                 | hd::tl -> last tl
                 | uu___4 ->
                     FStar_Compiler_Effect.failwith "last of an empty list" in
               let first_two_explicit args1 =
                 let rec drop_implicits args2 =
                   match args2 with
                   | (uu___3, FStar_Pervasives_Native.Some
                      { FStar_Syntax_Syntax.aqual_implicit = true;
                        FStar_Syntax_Syntax.aqual_attributes = uu___4;_})::tl
                       -> drop_implicits tl
                   | uu___3 -> args2 in
                 let uu___3 = drop_implicits args1 in
                 match uu___3 with
                 | [] ->
                     FStar_Compiler_Effect.failwith
                       "not_enough explicit_arguments"
                 | uu___4::[] ->
                     FStar_Compiler_Effect.failwith
                       "not_enough explicit_arguments"
                 | a1::a2::uu___4 -> [a1; a2] in
               let resugar_as_app e1 args1 =
                 let args2 =
                   FStar_Compiler_List.map
                     (fun uu___3 ->
                        match uu___3 with
                        | (e2, qual) ->
                            let uu___4 = resugar_term' env e2 in
                            let uu___5 = resugar_aqual env qual in
                            (uu___4, uu___5)) args1 in
                 let uu___3 = resugar_term' env e1 in
                 match uu___3 with
                 | {
                     FStar_Parser_AST.tm = FStar_Parser_AST.Construct
                       (hd, previous_args);
                     FStar_Parser_AST.range = r;
                     FStar_Parser_AST.level = l;_} ->
                     FStar_Parser_AST.mk_term
                       (FStar_Parser_AST.Construct
                          (hd,
                            (FStar_Compiler_List.op_At previous_args args2)))
                       r l
                 | e2 ->
                     FStar_Compiler_List.fold_left
                       (fun acc ->
                          fun uu___4 ->
                            match uu___4 with
                            | (x, qual) ->
                                mk (FStar_Parser_AST.App (acc, x, qual))) e2
                       args2 in
               let args1 =
                 let uu___3 = FStar_Options.print_implicits () in
                 if uu___3 then args else filter_imp_args args in
               let is_projector t2 =
                 let uu___3 =
                   let uu___4 =
                     let uu___5 = FStar_Syntax_Subst.compress t2 in
                     FStar_Syntax_Util.un_uinst uu___5 in
                   uu___4.FStar_Syntax_Syntax.n in
                 match uu___3 with
                 | FStar_Syntax_Syntax.Tm_fvar fv ->
                     let a =
                       (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
                     let length =
                       let uu___4 =
                         FStar_Ident.nsstr
                           (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
                       FStar_Compiler_String.length uu___4 in
                     let s =
                       if length = Prims.int_zero
                       then FStar_Ident.string_of_lid a
                       else
                         (let uu___5 = FStar_Ident.string_of_lid a in
                          FStar_Compiler_Util.substring_from uu___5
                            (length + Prims.int_one)) in
                     if
                       FStar_Compiler_Util.starts_with s
                         FStar_Syntax_Util.field_projector_prefix
                     then
                       let rest =
                         FStar_Compiler_Util.substring_from s
                           (FStar_Compiler_String.length
                              FStar_Syntax_Util.field_projector_prefix) in
                       let r =
                         FStar_Compiler_Util.split rest
                           FStar_Syntax_Util.field_projector_sep in
                       (match r with
                        | fst::snd::[] ->
                            let l =
                              FStar_Ident.lid_of_path [fst]
                                t2.FStar_Syntax_Syntax.pos in
                            let r1 =
                              FStar_Ident.mk_ident
                                (snd, (t2.FStar_Syntax_Syntax.pos)) in
                            FStar_Pervasives_Native.Some (l, r1)
                        | uu___4 ->
                            FStar_Compiler_Effect.failwith
                              "wrong projector format")
                     else FStar_Pervasives_Native.None
                 | uu___4 -> FStar_Pervasives_Native.None in
               let uu___3 =
                 ((let uu___4 = is_projector e in
                   FStar_Pervasives_Native.uu___is_Some uu___4) &&
                    ((FStar_Compiler_List.length args1) >= Prims.int_one))
                   &&
                   (let uu___4 =
                      let uu___5 = FStar_Compiler_List.hd args1 in
                      FStar_Pervasives_Native.snd uu___5 in
                    FStar_Pervasives_Native.uu___is_None uu___4) in
               if uu___3
               then
                 let uu___4 = args1 in
                 (match uu___4 with
                  | arg1::rest_args ->
                      let uu___5 =
                        let uu___6 = is_projector e in
                        FStar_Pervasives_Native.__proj__Some__item__v uu___6 in
                      (match uu___5 with
                       | (uu___6, fi) ->
                           let arg =
                             resugar_term' env
                               (FStar_Pervasives_Native.fst arg1) in
                           let h =
                             let uu___7 =
                               let uu___8 =
                                 let uu___9 = FStar_Ident.lid_of_ids [fi] in
                                 (arg, uu___9) in
                               FStar_Parser_AST.Project uu___8 in
                             mk uu___7 in
                           FStar_Compiler_List.fold_left
                             (fun acc ->
                                fun uu___7 ->
                                  match uu___7 with
                                  | (a, q) ->
                                      let aa = resugar_term' env a in
                                      let qq = resugar_aqual env q in
                                      mk (FStar_Parser_AST.App (acc, aa, qq)))
                             h rest_args))
               else
                 (let unsnoc l =
                    let rec unsnoc' acc uu___5 =
                      match uu___5 with
                      | [] ->
                          FStar_Compiler_Effect.failwith "unsnoc: empty list"
                      | x::[] -> ((FStar_Compiler_List.rev acc), x)
                      | x::xs -> unsnoc' (x :: acc) xs in
                    unsnoc' [] l in
                  let resugar_tuple_type env1 args2 =
                    let typs =
                      FStar_Compiler_List.map
                        (fun uu___5 ->
                           match uu___5 with
                           | (x, uu___6) -> resugar_term' env1 x) args2 in
                    let uu___5 = unsnoc typs in
                    match uu___5 with
                    | (pre, last1) ->
                        let uu___6 =
                          let uu___7 =
                            let uu___8 =
                              FStar_Compiler_List.map
                                (fun uu___9 -> FStar_Pervasives.Inr uu___9)
                                pre in
                            (uu___8, last1) in
                          FStar_Parser_AST.Sum uu___7 in
                        mk uu___6 in
                  let resugar_dtuple_type env1 hd args2 =
                    let fancy_resugar uu___5 =
                      (fun uu___5 ->
                         let n = FStar_Compiler_List.length args2 in
                         let take n1 l =
                           let uu___6 = FStar_Compiler_List.splitAt n1 l in
                           FStar_Pervasives_Native.fst uu___6 in
                         let uu___6 =
                           let uu___7 =
                             let uu___8 = FStar_Compiler_List.last args2 in
                             FStar_Pervasives_Native.fst uu___8 in
                           FStar_Syntax_Util.abs_formals uu___7 in
                         match uu___6 with
                         | (bs, uu___7, uu___8) ->
                             Obj.magic
                               (FStar_Class_Monad.op_let_Bang
                                  FStar_Class_Monad.monad_option () ()
                                  (if
                                     (FStar_Compiler_List.length bs) <
                                       (n - Prims.int_one)
                                   then FStar_Pervasives_Native.None
                                   else FStar_Pervasives_Native.Some ())
                                  (fun uu___9 ->
                                     (fun uu___9 ->
                                        let uu___9 = Obj.magic uu___9 in
                                        let bs1 = take (n - Prims.int_one) bs in
                                        let concatM uu___10 l =
                                          FStar_Class_Monad.mapM uu___10 ()
                                            ()
                                            (fun uu___11 ->
                                               (fun x ->
                                                  let x = Obj.magic x in
                                                  Obj.magic x) uu___11)
                                            (Obj.magic l) in
                                        let rec open_lambda_binders uu___11
                                          uu___10 =
                                          (fun t2 ->
                                             fun bs2 ->
                                               match bs2 with
                                               | [] ->
                                                   Obj.magic
                                                     (Obj.repr
                                                        (FStar_Pervasives_Native.Some
                                                           t2))
                                               | b::bs3 ->
                                                   Obj.magic
                                                     (Obj.repr
                                                        (let uu___10 =
                                                           FStar_Syntax_Util.abs_one_ln
                                                             t2 in
                                                         FStar_Class_Monad.op_let_Bang
                                                           FStar_Class_Monad.monad_option
                                                           () ()
                                                           (Obj.magic uu___10)
                                                           (fun uu___11 ->
                                                              (fun uu___11 ->
                                                                 let uu___11
                                                                   =
                                                                   Obj.magic
                                                                    uu___11 in
                                                                 match uu___11
                                                                 with
                                                                 | (uu___12,
                                                                    body) ->
                                                                    let uu___13
                                                                    =
                                                                    FStar_Syntax_Subst.open_term
                                                                    [b] body in
                                                                    (match uu___13
                                                                    with
                                                                    | 
                                                                    (uu___14,
                                                                    body1) ->
                                                                    Obj.magic
                                                                    (open_lambda_binders
                                                                    body1 bs3)))
                                                                uu___11))))
                                            uu___11 uu___10 in
                                        let uu___10 =
                                          Obj.magic
                                            (FStar_Class_Monad.mapMi
                                               FStar_Class_Monad.monad_option
                                               () ()
                                               (fun uu___12 ->
                                                  fun uu___11 ->
                                                    (fun i ->
                                                       fun uu___11 ->
                                                         let uu___11 =
                                                           Obj.magic uu___11 in
                                                         match uu___11 with
                                                         | (t2, uu___12) ->
                                                             let uu___13 =
                                                               take i bs1 in
                                                             Obj.magic
                                                               (open_lambda_binders
                                                                  t2 uu___13))
                                                      uu___12 uu___11)
                                               (Obj.magic args2)) in
                                        Obj.magic
                                          (FStar_Class_Monad.op_let_Bang
                                             FStar_Class_Monad.monad_option
                                             () () (Obj.magic uu___10)
                                             (fun uu___11 ->
                                                (fun opened_bs_types ->
                                                   let opened_bs_types =
                                                     Obj.magic
                                                       opened_bs_types in
                                                   let set_binder_sort t2 b =
                                                     {
                                                       FStar_Syntax_Syntax.binder_bv
                                                         =
                                                         (let uu___11 =
                                                            b.FStar_Syntax_Syntax.binder_bv in
                                                          {
                                                            FStar_Syntax_Syntax.ppname
                                                              =
                                                              (uu___11.FStar_Syntax_Syntax.ppname);
                                                            FStar_Syntax_Syntax.index
                                                              =
                                                              (uu___11.FStar_Syntax_Syntax.index);
                                                            FStar_Syntax_Syntax.sort
                                                              = t2
                                                          });
                                                       FStar_Syntax_Syntax.binder_qual
                                                         =
                                                         (b.FStar_Syntax_Syntax.binder_qual);
                                                       FStar_Syntax_Syntax.binder_positivity
                                                         =
                                                         (b.FStar_Syntax_Syntax.binder_positivity);
                                                       FStar_Syntax_Syntax.binder_attrs
                                                         =
                                                         (b.FStar_Syntax_Syntax.binder_attrs)
                                                     } in
                                                   let uu___11 =
                                                     unsnoc opened_bs_types in
                                                   match uu___11 with
                                                   | (pre_bs_types,
                                                      last_type) ->
                                                       let bs2 =
                                                         FStar_Compiler_List.map2
                                                           (fun b ->
                                                              fun t2 ->
                                                                let b1 =
                                                                  set_binder_sort
                                                                    t2 b in
                                                                let uu___12 =
                                                                  resugar_binder'
                                                                    env1 b1
                                                                    t2.FStar_Syntax_Syntax.pos in
                                                                FStar_Compiler_Util.must
                                                                  uu___12)
                                                           bs1 pre_bs_types in
                                                       let uu___12 =
                                                         let uu___13 =
                                                           let uu___14 =
                                                             let uu___15 =
                                                               FStar_Compiler_List.map
                                                                 (fun uu___16
                                                                    ->
                                                                    FStar_Pervasives.Inl
                                                                    uu___16)
                                                                 bs2 in
                                                             let uu___16 =
                                                               resugar_term'
                                                                 env1
                                                                 last_type in
                                                             (uu___15,
                                                               uu___16) in
                                                           FStar_Parser_AST.Sum
                                                             uu___14 in
                                                         mk uu___13 in
                                                       Obj.magic
                                                         (FStar_Pervasives_Native.Some
                                                            uu___12)) uu___11)))
                                       uu___9))) uu___5 in
                    let uu___5 = fancy_resugar () in
                    match uu___5 with
                    | FStar_Pervasives_Native.Some r -> r
                    | FStar_Pervasives_Native.None -> resugar_as_app hd args2 in
                  let uu___5 = is_list_literal t1 in
                  match uu___5 with
                  | FStar_Pervasives_Native.Some ts ->
                      let uu___6 =
                        let uu___7 =
                          FStar_Compiler_List.map (resugar_term' env) ts in
                        FStar_Parser_AST.ListLiteral uu___7 in
                      mk uu___6
                  | FStar_Pervasives_Native.None ->
                      let uu___6 = is_seq_literal t1 in
                      (match uu___6 with
                       | FStar_Pervasives_Native.Some ts ->
                           let uu___7 =
                             let uu___8 =
                               FStar_Compiler_List.map (resugar_term' env) ts in
                             FStar_Parser_AST.SeqLiteral uu___8 in
                           mk uu___7
                       | FStar_Pervasives_Native.None ->
                           let uu___7 = resugar_term_as_op e in
                           (match uu___7 with
                            | FStar_Pervasives_Native.None ->
                                resugar_as_app e args1
                            | FStar_Pervasives_Native.Some
                                ("calc_finish", uu___8) ->
                                let uu___9 = resugar_calc env t1 in
                                (match uu___9 with
                                 | FStar_Pervasives_Native.Some r -> r
                                 | uu___10 -> resugar_as_app e args1)
                            | FStar_Pervasives_Native.Some ("tuple", n) when
                                (FStar_Pervasives_Native.Some
                                   (FStar_Compiler_List.length args1))
                                  = n
                                -> resugar_tuple_type env args1
                            | FStar_Pervasives_Native.Some ("dtuple", n) when
                                (FStar_Pervasives_Native.Some
                                   (FStar_Compiler_List.length args1))
                                  = n
                                -> resugar_dtuple_type env e args1
                            | FStar_Pervasives_Native.Some (ref_read, uu___8)
                                when
                                let uu___9 =
                                  FStar_Ident.string_of_lid
                                    FStar_Parser_Const.sread_lid in
                                ref_read = uu___9 ->
                                let uu___9 = FStar_Compiler_List.hd args1 in
                                (match uu___9 with
                                 | (t2, uu___10) ->
                                     let uu___11 =
                                       let uu___12 =
                                         FStar_Syntax_Subst.compress t2 in
                                       uu___12.FStar_Syntax_Syntax.n in
                                     (match uu___11 with
                                      | FStar_Syntax_Syntax.Tm_fvar fv when
                                          let uu___12 =
                                            FStar_Ident.string_of_lid
                                              (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
                                          FStar_Syntax_Util.field_projector_contains_constructor
                                            uu___12
                                          ->
                                          let f =
                                            let uu___12 =
                                              let uu___13 =
                                                FStar_Ident.string_of_lid
                                                  (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
                                              [uu___13] in
                                            FStar_Ident.lid_of_path uu___12
                                              t2.FStar_Syntax_Syntax.pos in
                                          let uu___12 =
                                            let uu___13 =
                                              let uu___14 =
                                                resugar_term' env t2 in
                                              (uu___14, f) in
                                            FStar_Parser_AST.Project uu___13 in
                                          mk uu___12
                                      | uu___12 -> resugar_term' env t2))
                            | FStar_Pervasives_Native.Some
                                ("try_with", uu___8) when
                                (FStar_Compiler_List.length args1) >
                                  Prims.int_one
                                ->
                                (try
                                   (fun uu___9 ->
                                      match () with
                                      | () ->
                                          let new_args =
                                            first_two_explicit args1 in
                                          let uu___10 =
                                            match new_args with
                                            | (a1, uu___11)::(a2, uu___12)::[]
                                                -> (a1, a2)
                                            | uu___11 ->
                                                FStar_Compiler_Effect.failwith
                                                  "wrong arguments to try_with" in
                                          (match uu___10 with
                                           | (body, handler) ->
                                               let decomp term =
                                                 let uu___11 =
                                                   let uu___12 =
                                                     FStar_Syntax_Subst.compress
                                                       term in
                                                   uu___12.FStar_Syntax_Syntax.n in
                                                 match uu___11 with
                                                 | FStar_Syntax_Syntax.Tm_abs
                                                     {
                                                       FStar_Syntax_Syntax.bs
                                                         = x;
                                                       FStar_Syntax_Syntax.body
                                                         = e1;
                                                       FStar_Syntax_Syntax.rc_opt
                                                         = uu___12;_}
                                                     ->
                                                     let uu___13 =
                                                       FStar_Syntax_Subst.open_term
                                                         x e1 in
                                                     (match uu___13 with
                                                      | (x1, e2) -> e2)
                                                 | uu___12 ->
                                                     let uu___13 =
                                                       let uu___14 =
                                                         let uu___15 =
                                                           resugar_term' env
                                                             term in
                                                         FStar_Parser_AST.term_to_string
                                                           uu___15 in
                                                       Prims.strcat
                                                         "wrong argument format to try_with: "
                                                         uu___14 in
                                                     FStar_Compiler_Effect.failwith
                                                       uu___13 in
                                               let body1 =
                                                 let uu___11 = decomp body in
                                                 resugar_term' env uu___11 in
                                               let handler1 =
                                                 let uu___11 = decomp handler in
                                                 resugar_term' env uu___11 in
                                               let rec resugar_body t2 =
                                                 match t2.FStar_Parser_AST.tm
                                                 with
                                                 | FStar_Parser_AST.Match
                                                     (e1,
                                                      FStar_Pervasives_Native.None,
                                                      FStar_Pervasives_Native.None,
                                                      (uu___11, uu___12, b)::[])
                                                     -> b
                                                 | FStar_Parser_AST.Let
                                                     (uu___11, uu___12, b) ->
                                                     b
                                                 | FStar_Parser_AST.Ascribed
                                                     (t11, t21, t3, use_eq)
                                                     ->
                                                     let uu___11 =
                                                       let uu___12 =
                                                         let uu___13 =
                                                           resugar_body t11 in
                                                         (uu___13, t21, t3,
                                                           use_eq) in
                                                       FStar_Parser_AST.Ascribed
                                                         uu___12 in
                                                     mk uu___11
                                                 | uu___11 ->
                                                     FStar_Compiler_Effect.failwith
                                                       "unexpected body format to try_with" in
                                               let e1 = resugar_body body1 in
                                               let rec resugar_branches t2 =
                                                 match t2.FStar_Parser_AST.tm
                                                 with
                                                 | FStar_Parser_AST.Match
                                                     (e2,
                                                      FStar_Pervasives_Native.None,
                                                      FStar_Pervasives_Native.None,
                                                      branches)
                                                     -> branches
                                                 | FStar_Parser_AST.Ascribed
                                                     (t11, t21, t3, uu___11)
                                                     -> resugar_branches t11
                                                 | uu___11 -> [] in
                                               let branches =
                                                 resugar_branches handler1 in
                                               mk
                                                 (FStar_Parser_AST.TryWith
                                                    (e1, branches)))) ()
                                 with | uu___9 -> resugar_as_app e args1)
                            | FStar_Pervasives_Native.Some
                                ("try_with", uu___8) ->
                                resugar_as_app e args1
                            | FStar_Pervasives_Native.Some (op, uu___8) when
                                (((((((op = "=") || (op = "==")) ||
                                       (op = "==="))
                                      || (op = "@"))
                                     || (op = ":="))
                                    || (op = "|>"))
                                   || (op = "<<"))
                                  && (FStar_Options.print_implicits ())
                                -> resugar_as_app e args1
                            | FStar_Pervasives_Native.Some (op, uu___8) when
                                (FStar_Compiler_Util.starts_with op "forall")
                                  ||
                                  (FStar_Compiler_Util.starts_with op
                                     "exists")
                                ->
                                let rec uncurry xs pats t2 flavor_matches =
                                  match t2.FStar_Parser_AST.tm with
                                  | FStar_Parser_AST.QExists
                                      (xs', (uu___9, pats'), body) when
                                      flavor_matches t2 ->
                                      uncurry
                                        (FStar_Compiler_List.op_At xs xs')
                                        (FStar_Compiler_List.op_At pats pats')
                                        body flavor_matches
                                  | FStar_Parser_AST.QForall
                                      (xs', (uu___9, pats'), body) when
                                      flavor_matches t2 ->
                                      uncurry
                                        (FStar_Compiler_List.op_At xs xs')
                                        (FStar_Compiler_List.op_At pats pats')
                                        body flavor_matches
                                  | FStar_Parser_AST.QuantOp
                                      (uu___9, xs', (uu___10, pats'), body)
                                      when flavor_matches t2 ->
                                      uncurry
                                        (FStar_Compiler_List.op_At xs xs')
                                        (FStar_Compiler_List.op_At pats pats')
                                        body flavor_matches
                                  | uu___9 -> (xs, pats, t2) in
                                let resugar_forall_body body =
                                  let uu___9 =
                                    let uu___10 =
                                      FStar_Syntax_Subst.compress body in
                                    uu___10.FStar_Syntax_Syntax.n in
                                  match uu___9 with
                                  | FStar_Syntax_Syntax.Tm_abs
                                      { FStar_Syntax_Syntax.bs = xs;
                                        FStar_Syntax_Syntax.body = body1;
                                        FStar_Syntax_Syntax.rc_opt = uu___10;_}
                                      ->
                                      let uu___11 =
                                        FStar_Syntax_Subst.open_term xs body1 in
                                      (match uu___11 with
                                       | (xs1, body2) ->
                                           let xs2 =
                                             let uu___12 =
                                               FStar_Options.print_implicits
                                                 () in
                                             if uu___12
                                             then xs1
                                             else filter_imp_bs xs1 in
                                           let xs3 =
                                             (map_opt ())
                                               (fun b ->
                                                  resugar_binder' env b
                                                    t1.FStar_Syntax_Syntax.pos)
                                               xs2 in
                                           let uu___12 =
                                             let uu___13 =
                                               let uu___14 =
                                                 FStar_Syntax_Subst.compress
                                                   body2 in
                                               uu___14.FStar_Syntax_Syntax.n in
                                             match uu___13 with
                                             | FStar_Syntax_Syntax.Tm_meta
                                                 {
                                                   FStar_Syntax_Syntax.tm2 =
                                                     e1;
                                                   FStar_Syntax_Syntax.meta =
                                                     m;_}
                                                 ->
                                                 let body3 =
                                                   resugar_term' env e1 in
                                                 let uu___14 =
                                                   match m with
                                                   | FStar_Syntax_Syntax.Meta_pattern
                                                       (uu___15, pats) ->
                                                       let uu___16 =
                                                         FStar_Compiler_List.map
                                                           (fun es ->
                                                              FStar_Compiler_List.map
                                                                (fun uu___17
                                                                   ->
                                                                   match uu___17
                                                                   with
                                                                   | 
                                                                   (e2,
                                                                    uu___18)
                                                                    ->
                                                                    resugar_term'
                                                                    env e2)
                                                                es) pats in
                                                       (uu___16, body3)
                                                   | FStar_Syntax_Syntax.Meta_labeled
                                                       (s, r, p) ->
                                                       let uu___15 =
                                                         let uu___16 =
                                                           let uu___17 =
                                                             let uu___18 =
                                                               FStar_Errors_Msg.rendermsg
                                                                 s in
                                                             (body3, uu___18,
                                                               p) in
                                                           FStar_Parser_AST.Labeled
                                                             uu___17 in
                                                         mk uu___16 in
                                                       ([], uu___15)
                                                   | uu___15 ->
                                                       FStar_Compiler_Effect.failwith
                                                         "wrong pattern format for QForall/QExists" in
                                                 (match uu___14 with
                                                  | (pats, body4) ->
                                                      (pats, body4))
                                             | uu___14 ->
                                                 let uu___15 =
                                                   resugar_term' env body2 in
                                                 ([], uu___15) in
                                           (match uu___12 with
                                            | (pats, body3) ->
                                                let decompile_op op1 =
                                                  let uu___13 =
                                                    FStar_Parser_AST.string_to_op
                                                      op1 in
                                                  match uu___13 with
                                                  | FStar_Pervasives_Native.None
                                                      -> op1
                                                  | FStar_Pervasives_Native.Some
                                                      (op2, uu___14) -> op2 in
                                                let flavor_matches t2 =
                                                  match ((t2.FStar_Parser_AST.tm),
                                                          op)
                                                  with
                                                  | (FStar_Parser_AST.QExists
                                                     uu___13, "exists") ->
                                                      true
                                                  | (FStar_Parser_AST.QForall
                                                     uu___13, "forall") ->
                                                      true
                                                  | (FStar_Parser_AST.QuantOp
                                                     (id, uu___13, uu___14,
                                                      uu___15),
                                                     uu___16) ->
                                                      let uu___17 =
                                                        FStar_Ident.string_of_id
                                                          id in
                                                      uu___17 = op
                                                  | uu___13 -> false in
                                                let uu___13 =
                                                  uncurry xs3 pats body3
                                                    flavor_matches in
                                                (match uu___13 with
                                                 | (xs4, pats1, body4) ->
                                                     let binders =
                                                       FStar_Parser_AST.idents_of_binders
                                                         xs4
                                                         t1.FStar_Syntax_Syntax.pos in
                                                     if op = "forall"
                                                     then
                                                       mk
                                                         (FStar_Parser_AST.QForall
                                                            (xs4,
                                                              (binders,
                                                                pats1),
                                                              body4))
                                                     else
                                                       if op = "exists"
                                                       then
                                                         mk
                                                           (FStar_Parser_AST.QExists
                                                              (xs4,
                                                                (binders,
                                                                  pats1),
                                                                body4))
                                                       else
                                                         (let uu___16 =
                                                            let uu___17 =
                                                              let uu___18 =
                                                                FStar_Ident.id_of_text
                                                                  op in
                                                              (uu___18, xs4,
                                                                (binders,
                                                                  pats1),
                                                                body4) in
                                                            FStar_Parser_AST.QuantOp
                                                              uu___17 in
                                                          mk uu___16))))
                                  | uu___10 ->
                                      if op = "forall"
                                      then
                                        let uu___11 =
                                          let uu___12 =
                                            let uu___13 =
                                              resugar_term' env body in
                                            ([], ([], []), uu___13) in
                                          FStar_Parser_AST.QForall uu___12 in
                                        mk uu___11
                                      else
                                        (let uu___12 =
                                           let uu___13 =
                                             let uu___14 =
                                               resugar_term' env body in
                                             ([], ([], []), uu___14) in
                                           FStar_Parser_AST.QExists uu___13 in
                                         mk uu___12) in
                                if
                                  (FStar_Compiler_List.length args1) >
                                    Prims.int_zero
                                then
                                  let args2 = last args1 in
                                  (match args2 with
                                   | (b, uu___9)::[] -> resugar_forall_body b
                                   | uu___9 ->
                                       FStar_Compiler_Effect.failwith
                                         "wrong args format to QForall")
                                else resugar_as_app e args1
                            | FStar_Pervasives_Native.Some ("alloc", uu___8)
                                ->
                                let uu___9 = FStar_Compiler_List.hd args1 in
                                (match uu___9 with
                                 | (e1, uu___10) -> resugar_term' env e1)
                            | FStar_Pervasives_Native.Some
                                (op, expected_arity1) ->
                                let op1 = FStar_Ident.id_of_text op in
                                let resugar args2 =
                                  FStar_Compiler_List.map
                                    (fun uu___8 ->
                                       match uu___8 with
                                       | (e1, qual) ->
                                           let uu___9 = resugar_term' env e1 in
                                           let uu___10 =
                                             resugar_aqual env qual in
                                           (uu___9, uu___10)) args2 in
                                (match expected_arity1 with
                                 | FStar_Pervasives_Native.None ->
                                     let resugared_args = resugar args1 in
                                     let expect_n =
                                       FStar_Parser_ToDocument.handleable_args_length
                                         op1 in
                                     if
                                       (FStar_Compiler_List.length
                                          resugared_args)
                                         >= expect_n
                                     then
                                       let uu___8 =
                                         FStar_Compiler_Util.first_N expect_n
                                           resugared_args in
                                       (match uu___8 with
                                        | (op_args, rest) ->
                                            let head =
                                              let uu___9 =
                                                let uu___10 =
                                                  let uu___11 =
                                                    FStar_Compiler_List.map
                                                      FStar_Pervasives_Native.fst
                                                      op_args in
                                                  (op1, uu___11) in
                                                FStar_Parser_AST.Op uu___10 in
                                              mk uu___9 in
                                            FStar_Compiler_List.fold_left
                                              (fun head1 ->
                                                 fun uu___9 ->
                                                   match uu___9 with
                                                   | (arg, qual) ->
                                                       mk
                                                         (FStar_Parser_AST.App
                                                            (head1, arg,
                                                              qual))) head
                                              rest)
                                     else resugar_as_app e args1
                                 | FStar_Pervasives_Native.Some n when
                                     (FStar_Compiler_List.length args1) = n
                                     ->
                                     let uu___8 =
                                       let uu___9 =
                                         let uu___10 =
                                           let uu___11 = resugar args1 in
                                           FStar_Compiler_List.map
                                             FStar_Pervasives_Native.fst
                                             uu___11 in
                                         (op1, uu___10) in
                                       FStar_Parser_AST.Op uu___9 in
                                     mk uu___8
                                 | uu___8 -> resugar_as_app e args1)))))
      | FStar_Syntax_Syntax.Tm_match
          { FStar_Syntax_Syntax.scrutinee = e;
            FStar_Syntax_Syntax.ret_opt = FStar_Pervasives_Native.None;
            FStar_Syntax_Syntax.brs = (pat, wopt, t1)::[];
            FStar_Syntax_Syntax.rc_opt1 = uu___1;_}
          ->
          let uu___2 = FStar_Syntax_Subst.open_branch (pat, wopt, t1) in
          (match uu___2 with
           | (pat1, wopt1, t2) ->
               let branch_bv = FStar_Syntax_Free.names t2 in
               let bnds =
                 let uu___3 =
                   let uu___4 =
                     let uu___5 = resugar_pat' env pat1 branch_bv in
                     let uu___6 = resugar_term' env e in (uu___5, uu___6) in
                   (FStar_Pervasives_Native.None, uu___4) in
                 [uu___3] in
               let body = resugar_term' env t2 in
               mk
                 (FStar_Parser_AST.Let
                    (FStar_Parser_AST.NoLetQualifier, bnds, body)))
      | FStar_Syntax_Syntax.Tm_match
          { FStar_Syntax_Syntax.scrutinee = e;
            FStar_Syntax_Syntax.ret_opt = asc_opt;
            FStar_Syntax_Syntax.brs = branches;
            FStar_Syntax_Syntax.rc_opt1 = uu___1;_}
          ->
          let resugar_branch uu___2 =
            match uu___2 with
            | (pat, wopt, b) ->
                let uu___3 = FStar_Syntax_Subst.open_branch (pat, wopt, b) in
                (match uu___3 with
                 | (pat1, wopt1, b1) ->
                     let branch_bv = FStar_Syntax_Free.names b1 in
                     let pat2 = resugar_pat' env pat1 branch_bv in
                     let wopt2 =
                       match wopt1 with
                       | FStar_Pervasives_Native.None ->
                           FStar_Pervasives_Native.None
                       | FStar_Pervasives_Native.Some e1 ->
                           let uu___4 = resugar_term' env e1 in
                           FStar_Pervasives_Native.Some uu___4 in
                     let b2 = resugar_term' env b1 in (pat2, wopt2, b2)) in
          let asc_opt1 =
            resugar_match_returns env e t.FStar_Syntax_Syntax.pos asc_opt in
          let uu___2 =
            let uu___3 =
              let uu___4 = resugar_term' env e in
              let uu___5 = FStar_Compiler_List.map resugar_branch branches in
              (uu___4, FStar_Pervasives_Native.None, asc_opt1, uu___5) in
            FStar_Parser_AST.Match uu___3 in
          mk uu___2
      | FStar_Syntax_Syntax.Tm_ascribed
          { FStar_Syntax_Syntax.tm = e; FStar_Syntax_Syntax.asc = asc;
            FStar_Syntax_Syntax.eff_opt = uu___1;_}
          ->
          let uu___2 = resugar_ascription env asc in
          (match uu___2 with
           | (asc1, tac_opt, b) ->
               let uu___3 =
                 let uu___4 =
                   let uu___5 = resugar_term' env e in
                   (uu___5, asc1, tac_opt, b) in
                 FStar_Parser_AST.Ascribed uu___4 in
               mk uu___3)
      | FStar_Syntax_Syntax.Tm_let
          { FStar_Syntax_Syntax.lbs = (is_rec, source_lbs);
            FStar_Syntax_Syntax.body1 = body;_}
          ->
          let mk_pat a =
            FStar_Parser_AST.mk_pattern a t.FStar_Syntax_Syntax.pos in
          let uu___1 = FStar_Syntax_Subst.open_let_rec source_lbs body in
          (match uu___1 with
           | (source_lbs1, body1) ->
               let resugar_one_binding bnd =
                 let attrs_opt =
                   match bnd.FStar_Syntax_Syntax.lbattrs with
                   | [] -> FStar_Pervasives_Native.None
                   | tms ->
                       let uu___2 =
                         FStar_Compiler_List.map (resugar_term' env) tms in
                       FStar_Pervasives_Native.Some uu___2 in
                 let uu___2 =
                   let uu___3 =
                     FStar_Syntax_Util.mk_conj bnd.FStar_Syntax_Syntax.lbtyp
                       bnd.FStar_Syntax_Syntax.lbdef in
                   FStar_Syntax_Subst.open_univ_vars
                     bnd.FStar_Syntax_Syntax.lbunivs uu___3 in
                 match uu___2 with
                 | (univs, td) ->
                     let uu___3 =
                       let uu___4 =
                         let uu___5 = FStar_Syntax_Subst.compress td in
                         uu___5.FStar_Syntax_Syntax.n in
                       match uu___4 with
                       | FStar_Syntax_Syntax.Tm_app
                           { FStar_Syntax_Syntax.hd = uu___5;
                             FStar_Syntax_Syntax.args =
                               (t1, uu___6)::(d, uu___7)::[];_}
                           -> (t1, d)
                       | uu___5 ->
                           FStar_Compiler_Effect.failwith
                             "wrong let binding format" in
                     (match uu___3 with
                      | (typ, def) ->
                          let uu___4 =
                            let uu___5 =
                              let uu___6 = FStar_Syntax_Subst.compress def in
                              uu___6.FStar_Syntax_Syntax.n in
                            match uu___5 with
                            | FStar_Syntax_Syntax.Tm_abs
                                { FStar_Syntax_Syntax.bs = b;
                                  FStar_Syntax_Syntax.body = t1;
                                  FStar_Syntax_Syntax.rc_opt = uu___6;_}
                                ->
                                let uu___7 =
                                  FStar_Syntax_Subst.open_term b t1 in
                                (match uu___7 with
                                 | (b1, t2) ->
                                     let b2 =
                                       let uu___8 =
                                         FStar_Options.print_implicits () in
                                       if uu___8
                                       then b1
                                       else filter_imp_bs b1 in
                                     (b2, t2, true))
                            | uu___6 -> ([], def, false) in
                          (match uu___4 with
                           | (binders, term, is_pat_app) ->
                               let uu___5 =
                                 match bnd.FStar_Syntax_Syntax.lbname with
                                 | FStar_Pervasives.Inr fv ->
                                     let uu___6 =
                                       mk_pat
                                         (FStar_Parser_AST.PatName
                                            ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v)) in
                                     (uu___6, term)
                                 | FStar_Pervasives.Inl bv ->
                                     let uu___6 =
                                       let uu___7 =
                                         let uu___8 =
                                           let uu___9 = bv_as_unique_ident bv in
                                           (uu___9,
                                             FStar_Pervasives_Native.None,
                                             []) in
                                         FStar_Parser_AST.PatVar uu___8 in
                                       mk_pat uu___7 in
                                     (uu___6, term) in
                               (match uu___5 with
                                | (pat, term1) ->
                                    let uu___6 =
                                      if is_pat_app
                                      then
                                        let args =
                                          (map_opt ())
                                            (fun b ->
                                               let uu___7 =
                                                 resugar_bqual env
                                                   b.FStar_Syntax_Syntax.binder_qual in
                                               FStar_Compiler_Util.map_opt
                                                 uu___7
                                                 (fun q ->
                                                    let uu___8 =
                                                      let uu___9 =
                                                        let uu___10 =
                                                          bv_as_unique_ident
                                                            b.FStar_Syntax_Syntax.binder_bv in
                                                        let uu___11 =
                                                          FStar_Compiler_List.map
                                                            (resugar_term'
                                                               env)
                                                            b.FStar_Syntax_Syntax.binder_attrs in
                                                        (uu___10, q, uu___11) in
                                                      FStar_Parser_AST.PatVar
                                                        uu___9 in
                                                    mk_pat uu___8)) binders in
                                        let uu___7 =
                                          let uu___8 =
                                            mk_pat
                                              (FStar_Parser_AST.PatApp
                                                 (pat, args)) in
                                          let uu___9 =
                                            resugar_term' env term1 in
                                          (uu___8, uu___9) in
                                        let uu___8 = universe_to_string univs in
                                        (uu___7, uu___8)
                                      else
                                        (let uu___8 =
                                           let uu___9 =
                                             resugar_term' env term1 in
                                           (pat, uu___9) in
                                         let uu___9 =
                                           universe_to_string univs in
                                         (uu___8, uu___9)) in
                                    (attrs_opt, uu___6)))) in
               let r =
                 FStar_Compiler_List.map resugar_one_binding source_lbs1 in
               let bnds =
                 let f uu___2 =
                   match uu___2 with
                   | (attrs, (pb, univs)) ->
                       let uu___3 =
                         let uu___4 = FStar_Options.print_universes () in
                         Prims.op_Negation uu___4 in
                       if uu___3
                       then (attrs, pb)
                       else
                         (let uu___5 =
                            let uu___6 =
                              label univs (FStar_Pervasives_Native.snd pb) in
                            ((FStar_Pervasives_Native.fst pb), uu___6) in
                          (attrs, uu___5)) in
                 FStar_Compiler_List.map f r in
               let body2 = resugar_term' env body1 in
               mk
                 (FStar_Parser_AST.Let
                    ((if is_rec
                      then FStar_Parser_AST.Rec
                      else FStar_Parser_AST.NoLetQualifier), bnds, body2)))
      | FStar_Syntax_Syntax.Tm_uvar (u, uu___1) ->
          let s =
            let uu___2 =
              let uu___3 =
                FStar_Syntax_Unionfind.uvar_id
                  u.FStar_Syntax_Syntax.ctx_uvar_head in
              FStar_Compiler_Util.string_of_int uu___3 in
            Prims.strcat "?u" uu___2 in
          let uu___2 = mk FStar_Parser_AST.Wild in label s uu___2
      | FStar_Syntax_Syntax.Tm_quoted (tm, qi) ->
          let qi1 =
            match qi.FStar_Syntax_Syntax.qkind with
            | FStar_Syntax_Syntax.Quote_static -> FStar_Parser_AST.Static
            | FStar_Syntax_Syntax.Quote_dynamic -> FStar_Parser_AST.Dynamic in
          let uu___1 =
            let uu___2 = let uu___3 = resugar_term' env tm in (uu___3, qi1) in
            FStar_Parser_AST.Quote uu___2 in
          mk uu___1
      | FStar_Syntax_Syntax.Tm_meta
          { FStar_Syntax_Syntax.tm2 = e; FStar_Syntax_Syntax.meta = m;_} ->
          let resugar_meta_desugared uu___1 =
            match uu___1 with
            | FStar_Syntax_Syntax.Sequence ->
                let term = resugar_term' env e in
                let rec resugar_seq t1 =
                  match t1.FStar_Parser_AST.tm with
                  | FStar_Parser_AST.Let (uu___2, (uu___3, (p, t11))::[], t2)
                      -> mk (FStar_Parser_AST.Seq (t11, t2))
                  | FStar_Parser_AST.Ascribed (t11, t2, t3, use_eq) ->
                      let uu___2 =
                        let uu___3 =
                          let uu___4 = resugar_seq t11 in
                          (uu___4, t2, t3, use_eq) in
                        FStar_Parser_AST.Ascribed uu___3 in
                      mk uu___2
                  | uu___2 -> t1 in
                resugar_seq term
            | FStar_Syntax_Syntax.Machine_integer (uu___2, uu___3) ->
                resugar_term' env e
            | FStar_Syntax_Syntax.Primop -> resugar_term' env e
            | FStar_Syntax_Syntax.Masked_effect -> resugar_term' env e
            | FStar_Syntax_Syntax.Meta_smt_pat -> resugar_term' env e in
          (match m with
           | FStar_Syntax_Syntax.Meta_labeled uu___1 -> resugar_term' env e
           | FStar_Syntax_Syntax.Meta_desugared i -> resugar_meta_desugared i
           | FStar_Syntax_Syntax.Meta_named t1 ->
               mk (FStar_Parser_AST.Name t1)
           | FStar_Syntax_Syntax.Meta_pattern uu___1 -> resugar_term' env e
           | FStar_Syntax_Syntax.Meta_monadic uu___1 -> resugar_term' env e
           | FStar_Syntax_Syntax.Meta_monadic_lift uu___1 ->
               resugar_term' env e)
      | FStar_Syntax_Syntax.Tm_unknown -> mk FStar_Parser_AST.Wild
and (resugar_ascription :
  FStar_Syntax_DsEnv.env ->
    ((FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,
      FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax)
      FStar_Pervasives.either * FStar_Syntax_Syntax.term'
      FStar_Syntax_Syntax.syntax FStar_Pervasives_Native.option * Prims.bool)
      ->
      (FStar_Parser_AST.term * FStar_Parser_AST.term
        FStar_Pervasives_Native.option * Prims.bool))
  =
  fun env ->
    fun uu___ ->
      match uu___ with
      | (asc, tac_opt, b) ->
          let uu___1 =
            match asc with
            | FStar_Pervasives.Inl n -> resugar_term' env n
            | FStar_Pervasives.Inr n -> resugar_comp' env n in
          let uu___2 =
            FStar_Compiler_Util.map_opt tac_opt (resugar_term' env) in
          (uu___1, uu___2, b)
and (resugar_calc :
  FStar_Syntax_DsEnv.env ->
    FStar_Syntax_Syntax.term ->
      FStar_Parser_AST.term FStar_Pervasives_Native.option)
  =
  fun env ->
    fun t0 ->
      let mk a =
        FStar_Parser_AST.mk_term a t0.FStar_Syntax_Syntax.pos
          FStar_Parser_AST.Un in
      let resugar_calc_finish t =
        let uu___ = FStar_Syntax_Util.head_and_args t in
        match uu___ with
        | (hd, args) ->
            let uu___1 =
              let uu___2 =
                let uu___3 =
                  let uu___4 = FStar_Syntax_Util.un_uinst hd in
                  FStar_Syntax_Subst.compress uu___4 in
                uu___3.FStar_Syntax_Syntax.n in
              (uu___2, args) in
            (match uu___1 with
             | (FStar_Syntax_Syntax.Tm_fvar fv,
                (uu___2, FStar_Pervasives_Native.Some
                 { FStar_Syntax_Syntax.aqual_implicit = true;
                   FStar_Syntax_Syntax.aqual_attributes = uu___3;_})::
                (rel, FStar_Pervasives_Native.None)::(uu___4,
                                                      FStar_Pervasives_Native.Some
                                                      {
                                                        FStar_Syntax_Syntax.aqual_implicit
                                                          = true;
                                                        FStar_Syntax_Syntax.aqual_attributes
                                                          = uu___5;_})::
                (uu___6, FStar_Pervasives_Native.Some
                 { FStar_Syntax_Syntax.aqual_implicit = true;
                   FStar_Syntax_Syntax.aqual_attributes = uu___7;_})::
                (uu___8, FStar_Pervasives_Native.Some
                 { FStar_Syntax_Syntax.aqual_implicit = true;
                   FStar_Syntax_Syntax.aqual_attributes = uu___9;_})::
                (pf, FStar_Pervasives_Native.None)::[]) when
                 FStar_Syntax_Syntax.fv_eq_lid fv
                   FStar_Parser_Const.calc_finish_lid
                 ->
                 let pf1 = FStar_Syntax_Util.unthunk pf in
                 FStar_Pervasives_Native.Some (rel, pf1)
             | uu___2 -> FStar_Pervasives_Native.None) in
      let un_eta_rel rel =
        let bv_eq_tm b t =
          let uu___ =
            let uu___1 = FStar_Syntax_Subst.compress t in
            uu___1.FStar_Syntax_Syntax.n in
          match uu___ with
          | FStar_Syntax_Syntax.Tm_name b' when
              FStar_Syntax_Syntax.bv_eq b b' -> true
          | uu___1 -> false in
        let uu___ =
          let uu___1 = FStar_Syntax_Subst.compress rel in
          uu___1.FStar_Syntax_Syntax.n in
        match uu___ with
        | FStar_Syntax_Syntax.Tm_abs
            { FStar_Syntax_Syntax.bs = b1::b2::[];
              FStar_Syntax_Syntax.body = body;
              FStar_Syntax_Syntax.rc_opt = uu___1;_}
            ->
            let uu___2 = FStar_Syntax_Subst.open_term [b1; b2] body in
            (match uu___2 with
             | (b11::b21::[], body1) ->
                 let body2 = FStar_Syntax_Util.unascribe body1 in
                 let body3 =
                   let uu___3 = FStar_Syntax_Util.unb2t body2 in
                   match uu___3 with
                   | FStar_Pervasives_Native.Some body4 -> body4
                   | FStar_Pervasives_Native.None -> body2 in
                 let uu___3 =
                   let uu___4 = FStar_Syntax_Subst.compress body3 in
                   uu___4.FStar_Syntax_Syntax.n in
                 (match uu___3 with
                  | FStar_Syntax_Syntax.Tm_app
                      { FStar_Syntax_Syntax.hd = e;
                        FStar_Syntax_Syntax.args = args;_}
                      when
                      (FStar_Compiler_List.length args) >= (Prims.of_int (2))
                      ->
                      (match FStar_Compiler_List.rev args with
                       | (a1, FStar_Pervasives_Native.None)::(a2,
                                                              FStar_Pervasives_Native.None)::rest
                           ->
                           let uu___4 =
                             (bv_eq_tm b11.FStar_Syntax_Syntax.binder_bv a2)
                               &&
                               (bv_eq_tm b21.FStar_Syntax_Syntax.binder_bv a1) in
                           if uu___4
                           then
                             let uu___5 =
                               FStar_Syntax_Util.mk_app e
                                 (FStar_Compiler_List.rev rest) in
                             FStar_Pervasives_Native.Some uu___5
                           else FStar_Pervasives_Native.Some rel
                       | uu___4 -> FStar_Pervasives_Native.Some rel)
                  | uu___4 -> FStar_Pervasives_Native.Some rel))
        | uu___1 -> FStar_Pervasives_Native.Some rel in
      let resugar_step pack =
        let uu___ = FStar_Syntax_Util.head_and_args pack in
        match uu___ with
        | (hd, args) ->
            let uu___1 =
              let uu___2 =
                let uu___3 =
                  let uu___4 = FStar_Syntax_Util.un_uinst hd in
                  FStar_Syntax_Subst.compress uu___4 in
                uu___3.FStar_Syntax_Syntax.n in
              (uu___2, args) in
            (match uu___1 with
             | (FStar_Syntax_Syntax.Tm_fvar fv,
                (uu___2, FStar_Pervasives_Native.Some
                 { FStar_Syntax_Syntax.aqual_implicit = true;
                   FStar_Syntax_Syntax.aqual_attributes = uu___3;_})::
                (uu___4, FStar_Pervasives_Native.Some
                 { FStar_Syntax_Syntax.aqual_implicit = true;
                   FStar_Syntax_Syntax.aqual_attributes = uu___5;_})::
                (uu___6, FStar_Pervasives_Native.Some
                 { FStar_Syntax_Syntax.aqual_implicit = true;
                   FStar_Syntax_Syntax.aqual_attributes = uu___7;_})::
                (rel, FStar_Pervasives_Native.None)::(z,
                                                      FStar_Pervasives_Native.None)::
                (uu___8, FStar_Pervasives_Native.Some
                 { FStar_Syntax_Syntax.aqual_implicit = true;
                   FStar_Syntax_Syntax.aqual_attributes = uu___9;_})::
                (pf, FStar_Pervasives_Native.None)::(j,
                                                     FStar_Pervasives_Native.None)::[])
                 when
                 FStar_Syntax_Syntax.fv_eq_lid fv
                   FStar_Parser_Const.calc_step_lid
                 ->
                 let pf1 = FStar_Syntax_Util.unthunk pf in
                 let j1 = FStar_Syntax_Util.unthunk j in
                 FStar_Pervasives_Native.Some (z, rel, j1, pf1)
             | uu___2 -> FStar_Pervasives_Native.None) in
      let resugar_init pack =
        let uu___ = FStar_Syntax_Util.head_and_args pack in
        match uu___ with
        | (hd, args) ->
            let uu___1 =
              let uu___2 =
                let uu___3 =
                  let uu___4 = FStar_Syntax_Util.un_uinst hd in
                  FStar_Syntax_Subst.compress uu___4 in
                uu___3.FStar_Syntax_Syntax.n in
              (uu___2, args) in
            (match uu___1 with
             | (FStar_Syntax_Syntax.Tm_fvar fv,
                (uu___2, FStar_Pervasives_Native.Some
                 { FStar_Syntax_Syntax.aqual_implicit = true;
                   FStar_Syntax_Syntax.aqual_attributes = uu___3;_})::
                (x, FStar_Pervasives_Native.None)::[]) when
                 FStar_Syntax_Syntax.fv_eq_lid fv
                   FStar_Parser_Const.calc_init_lid
                 -> FStar_Pervasives_Native.Some x
             | uu___2 -> FStar_Pervasives_Native.None) in
      let rec resugar_all_steps pack =
        let uu___ = resugar_step pack in
        match uu___ with
        | FStar_Pervasives_Native.Some (t, r, j, k) ->
            let uu___1 = resugar_all_steps k in
            FStar_Compiler_Util.bind_opt uu___1
              (fun uu___2 ->
                 match uu___2 with
                 | (steps, k1) ->
                     FStar_Pervasives_Native.Some (((t, r, j) :: steps), k1))
        | FStar_Pervasives_Native.None ->
            FStar_Pervasives_Native.Some ([], pack) in
      let resugar_rel rel =
        let rel1 =
          let uu___ = un_eta_rel rel in
          match uu___ with
          | FStar_Pervasives_Native.Some rel2 -> rel2
          | FStar_Pervasives_Native.None -> rel in
        let fallback uu___ =
          let uu___1 =
            let uu___2 = resugar_term' env rel1 in
            FStar_Parser_AST.Paren uu___2 in
          mk uu___1 in
        let uu___ = FStar_Syntax_Util.head_and_args rel1 in
        match uu___ with
        | (hd, args) ->
            let uu___1 =
              (FStar_Options.print_implicits ()) &&
                (FStar_Compiler_List.existsb
                   (fun uu___2 ->
                      match uu___2 with
                      | (uu___3, q) ->
                          FStar_Syntax_Syntax.is_aqual_implicit q) args) in
            if uu___1
            then fallback ()
            else
              (let uu___3 = resugar_term_as_op hd in
               match uu___3 with
               | FStar_Pervasives_Native.Some
                   (s, FStar_Pervasives_Native.None) ->
                   let uu___4 =
                     let uu___5 =
                       let uu___6 = FStar_Ident.id_of_text s in (uu___6, []) in
                     FStar_Parser_AST.Op uu___5 in
                   mk uu___4
               | FStar_Pervasives_Native.Some
                   (s, FStar_Pervasives_Native.Some uu___4) when
                   uu___4 = (Prims.of_int (2)) ->
                   let uu___5 =
                     let uu___6 =
                       let uu___7 = FStar_Ident.id_of_text s in (uu___7, []) in
                     FStar_Parser_AST.Op uu___6 in
                   mk uu___5
               | uu___4 -> fallback ()) in
      let build_calc rel x0 steps =
        let r = resugar_term' env in
        let uu___ =
          let uu___1 =
            let uu___2 = resugar_rel rel in
            let uu___3 = r x0 in
            let uu___4 =
              FStar_Compiler_List.map
                (fun uu___5 ->
                   match uu___5 with
                   | (z, rel1, j) ->
                       let uu___6 =
                         let uu___7 = resugar_rel rel1 in
                         let uu___8 = r j in
                         let uu___9 = r z in (uu___7, uu___8, uu___9) in
                       FStar_Parser_AST.CalcStep uu___6) steps in
            (uu___2, uu___3, uu___4) in
          FStar_Parser_AST.CalcProof uu___1 in
        mk uu___ in
      let uu___ = resugar_calc_finish t0 in
      FStar_Compiler_Util.bind_opt uu___
        (fun uu___1 ->
           match uu___1 with
           | (rel, pack) ->
               let uu___2 = resugar_all_steps pack in
               FStar_Compiler_Util.bind_opt uu___2
                 (fun uu___3 ->
                    match uu___3 with
                    | (steps, k) ->
                        let uu___4 = resugar_init k in
                        FStar_Compiler_Util.bind_opt uu___4
                          (fun x0 ->
                             let uu___5 =
                               build_calc rel x0
                                 (FStar_Compiler_List.rev steps) in
                             FStar_Pervasives_Native.Some uu___5)))
and (resugar_match_returns :
  FStar_Syntax_DsEnv.env ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Compiler_Range_Type.range ->
        (FStar_Syntax_Syntax.binder *
          ((FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,
          FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax)
          FStar_Pervasives.either * FStar_Syntax_Syntax.term'
          FStar_Syntax_Syntax.syntax FStar_Pervasives_Native.option *
          Prims.bool)) FStar_Pervasives_Native.option ->
          (FStar_Ident.ident FStar_Pervasives_Native.option *
            FStar_Parser_AST.term * Prims.bool)
            FStar_Pervasives_Native.option)
  =
  fun env ->
    fun scrutinee ->
      fun r ->
        fun asc_opt ->
          match asc_opt with
          | FStar_Pervasives_Native.None -> FStar_Pervasives_Native.None
          | FStar_Pervasives_Native.Some (b, asc) ->
              let uu___ =
                let uu___1 = FStar_Syntax_Subst.open_ascription [b] asc in
                match uu___1 with
                | (bs, asc1) ->
                    let b1 = FStar_Compiler_List.hd bs in
                    let uu___2 =
                      let uu___3 =
                        FStar_Ident.string_of_id
                          (b1.FStar_Syntax_Syntax.binder_bv).FStar_Syntax_Syntax.ppname in
                      uu___3 = FStar_Parser_Const.match_returns_def_name in
                    if uu___2
                    then
                      let uu___3 =
                        let uu___4 =
                          let uu___5 = FStar_Syntax_Subst.compress scrutinee in
                          FStar_Syntax_Util.unascribe uu___5 in
                        uu___4.FStar_Syntax_Syntax.n in
                      (match uu___3 with
                       | FStar_Syntax_Syntax.Tm_name sbv ->
                           let uu___4 =
                             let uu___5 =
                               let uu___6 =
                                 let uu___7 =
                                   let uu___8 =
                                     FStar_Syntax_Syntax.bv_to_name sbv in
                                   ((b1.FStar_Syntax_Syntax.binder_bv),
                                     uu___8) in
                                 FStar_Syntax_Syntax.NT uu___7 in
                               [uu___6] in
                             FStar_Syntax_Subst.subst_ascription uu___5 asc1 in
                           (FStar_Pervasives_Native.None, uu___4)
                       | uu___4 -> (FStar_Pervasives_Native.None, asc1))
                    else ((FStar_Pervasives_Native.Some b1), asc1) in
              (match uu___ with
               | (bopt, asc1) ->
                   let bopt1 =
                     FStar_Compiler_Util.map_option
                       (fun b1 ->
                          let uu___1 =
                            let uu___2 = resugar_binder' env b1 r in
                            FStar_Compiler_Util.must uu___2 in
                          FStar_Parser_AST.ident_of_binder r uu___1) bopt in
                   let uu___1 =
                     let uu___2 = resugar_ascription env asc1 in
                     match uu___2 with
                     | (asc2, FStar_Pervasives_Native.None, use_eq) ->
                         (asc2, use_eq)
                     | uu___3 ->
                         FStar_Compiler_Effect.failwith
                           "resugaring does not support match return annotation with a tactic" in
                   (match uu___1 with
                    | (asc2, use_eq) ->
                        FStar_Pervasives_Native.Some (bopt1, asc2, use_eq)))
and (resugar_comp' :
  FStar_Syntax_DsEnv.env -> FStar_Syntax_Syntax.comp -> FStar_Parser_AST.term)
  =
  fun env ->
    fun c ->
      let mk a =
        FStar_Parser_AST.mk_term a c.FStar_Syntax_Syntax.pos
          FStar_Parser_AST.Un in
      match c.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Total typ ->
          let t = resugar_term' env typ in
          let uu___ =
            let uu___1 = FStar_Options.print_implicits () in
            Prims.op_Negation uu___1 in
          if uu___
          then t
          else
            mk
              (FStar_Parser_AST.Construct
                 (FStar_Parser_Const.effect_Tot_lid,
                   [(t, FStar_Parser_AST.Nothing)]))
      | FStar_Syntax_Syntax.GTotal typ ->
          let t = resugar_term' env typ in
          mk
            (FStar_Parser_AST.Construct
               (FStar_Parser_Const.effect_GTot_lid,
                 [(t, FStar_Parser_AST.Nothing)]))
      | FStar_Syntax_Syntax.Comp c1 ->
          let result =
            let uu___ = resugar_term' env c1.FStar_Syntax_Syntax.result_typ in
            (uu___, FStar_Parser_AST.Nothing) in
          let mk_decreases fl =
            let rec aux l uu___ =
              match uu___ with
              | [] -> l
              | hd::tl ->
                  (match hd with
                   | FStar_Syntax_Syntax.DECREASES dec_order ->
                       let d =
                         match dec_order with
                         | FStar_Syntax_Syntax.Decreases_lex (t::[]) ->
                             resugar_term' env t
                         | FStar_Syntax_Syntax.Decreases_lex ts ->
                             let uu___1 =
                               let uu___2 =
                                 FStar_Compiler_List.map (resugar_term' env)
                                   ts in
                               FStar_Parser_AST.LexList uu___2 in
                             mk uu___1
                         | FStar_Syntax_Syntax.Decreases_wf (rel, e) ->
                             let uu___1 =
                               let uu___2 =
                                 let uu___3 = resugar_term' env rel in
                                 let uu___4 = resugar_term' env e in
                                 (uu___3, uu___4) in
                               FStar_Parser_AST.WFOrder uu___2 in
                             mk uu___1 in
                       let e =
                         mk
                           (FStar_Parser_AST.Decreases
                              (d, FStar_Pervasives_Native.None)) in
                       aux (e :: l) tl
                   | uu___1 -> aux l tl) in
            aux [] fl in
          let uu___ =
            (FStar_Ident.lid_equals c1.FStar_Syntax_Syntax.effect_name
               FStar_Parser_Const.effect_Lemma_lid)
              &&
              ((FStar_Compiler_List.length c1.FStar_Syntax_Syntax.effect_args)
                 = (Prims.of_int (3))) in
          if uu___
          then
            let args =
              FStar_Compiler_List.map
                (fun uu___1 ->
                   match uu___1 with
                   | (e, uu___2) ->
                       let uu___3 = resugar_term' env e in
                       (uu___3, FStar_Parser_AST.Nothing))
                c1.FStar_Syntax_Syntax.effect_args in
            let uu___1 =
              match c1.FStar_Syntax_Syntax.effect_args with
              | (pre, uu___2)::(post, uu___3)::(pats, uu___4)::[] ->
                  (pre, post, pats)
              | uu___2 -> FStar_Compiler_Effect.failwith "impossible" in
            (match uu___1 with
             | (pre, post, pats) ->
                 let pre1 =
                   let uu___2 =
                     FStar_Syntax_Util.is_fvar FStar_Parser_Const.true_lid
                       pre in
                   if uu___2 then [] else [pre] in
                 let post1 = FStar_Syntax_Util.unthunk_lemma_post post in
                 let pats1 =
                   let uu___2 =
                     let uu___3 = FStar_Syntax_Util.head_of pats in
                     FStar_Syntax_Util.is_fvar FStar_Parser_Const.nil_lid
                       uu___3 in
                   if uu___2 then [] else [pats] in
                 let pre2 =
                   FStar_Compiler_List.map
                     (fun t ->
                        let uu___2 =
                          let uu___3 =
                            let uu___4 = resugar_term' env t in
                            (uu___4, FStar_Pervasives_Native.None) in
                          FStar_Parser_AST.Requires uu___3 in
                        mk uu___2) pre1 in
                 let post2 =
                   let uu___2 =
                     let uu___3 =
                       let uu___4 = resugar_term' env post1 in
                       (uu___4, FStar_Pervasives_Native.None) in
                     FStar_Parser_AST.Ensures uu___3 in
                   mk uu___2 in
                 let pats2 =
                   FStar_Compiler_List.map (resugar_term' env) pats1 in
                 let decrease = mk_decreases c1.FStar_Syntax_Syntax.flags in
                 let uu___2 =
                   let uu___3 =
                     let uu___4 =
                       maybe_shorten_lid env
                         c1.FStar_Syntax_Syntax.effect_name in
                     let uu___5 =
                       FStar_Compiler_List.map
                         (fun t -> (t, FStar_Parser_AST.Nothing))
                         (FStar_Compiler_List.op_At pre2
                            (FStar_Compiler_List.op_At (post2 :: decrease)
                               pats2)) in
                     (uu___4, uu___5) in
                   FStar_Parser_AST.Construct uu___3 in
                 mk uu___2)
          else
            (let uu___2 = FStar_Options.print_effect_args () in
             if uu___2
             then
               let args =
                 FStar_Compiler_List.map
                   (fun uu___3 ->
                      match uu___3 with
                      | (e, uu___4) ->
                          let uu___5 = resugar_term' env e in
                          (uu___5, FStar_Parser_AST.Nothing))
                   c1.FStar_Syntax_Syntax.effect_args in
               let decrease =
                 let uu___3 = mk_decreases c1.FStar_Syntax_Syntax.flags in
                 FStar_Compiler_List.map
                   (fun t -> (t, FStar_Parser_AST.Nothing)) uu___3 in
               let uu___3 =
                 let uu___4 =
                   let uu___5 =
                     maybe_shorten_lid env c1.FStar_Syntax_Syntax.effect_name in
                   (uu___5,
                     (FStar_Compiler_List.op_At (result :: decrease) args)) in
                 FStar_Parser_AST.Construct uu___4 in
               mk uu___3
             else
               (let uu___4 =
                  let uu___5 =
                    let uu___6 =
                      maybe_shorten_lid env
                        c1.FStar_Syntax_Syntax.effect_name in
                    (uu___6, [result]) in
                  FStar_Parser_AST.Construct uu___5 in
                mk uu___4))
and (resugar_binder' :
  FStar_Syntax_DsEnv.env ->
    FStar_Syntax_Syntax.binder ->
      FStar_Compiler_Range_Type.range ->
        FStar_Parser_AST.binder FStar_Pervasives_Native.option)
  =
  fun uu___2 ->
    fun uu___1 ->
      fun uu___ ->
        (fun env ->
           fun b ->
             fun r ->
               let uu___ =
                 resugar_bqual env b.FStar_Syntax_Syntax.binder_qual in
               Obj.magic
                 (FStar_Class_Monad.op_let_Bang
                    FStar_Class_Monad.monad_option () () (Obj.magic uu___)
                    (fun uu___1 ->
                       (fun imp ->
                          let imp = Obj.magic imp in
                          let e =
                            resugar_term' env
                              (b.FStar_Syntax_Syntax.binder_bv).FStar_Syntax_Syntax.sort in
                          match e.FStar_Parser_AST.tm with
                          | FStar_Parser_AST.Wild ->
                              let uu___1 =
                                let uu___2 =
                                  let uu___3 =
                                    bv_as_unique_ident
                                      b.FStar_Syntax_Syntax.binder_bv in
                                  FStar_Parser_AST.Variable uu___3 in
                                FStar_Parser_AST.mk_binder uu___2 r
                                  FStar_Parser_AST.Type_level imp in
                              Obj.magic (FStar_Pervasives_Native.Some uu___1)
                          | uu___1 ->
                              let uu___2 =
                                FStar_Syntax_Syntax.is_null_bv
                                  b.FStar_Syntax_Syntax.binder_bv in
                              if uu___2
                              then
                                let uu___3 =
                                  FStar_Parser_AST.mk_binder
                                    (FStar_Parser_AST.NoName e) r
                                    FStar_Parser_AST.Type_level imp in
                                Obj.magic
                                  (FStar_Pervasives_Native.Some uu___3)
                              else
                                (let uu___4 =
                                   let uu___5 =
                                     let uu___6 =
                                       let uu___7 =
                                         bv_as_unique_ident
                                           b.FStar_Syntax_Syntax.binder_bv in
                                       (uu___7, e) in
                                     FStar_Parser_AST.Annotated uu___6 in
                                   FStar_Parser_AST.mk_binder uu___5 r
                                     FStar_Parser_AST.Type_level imp in
                                 Obj.magic
                                   (FStar_Pervasives_Native.Some uu___4)))
                         uu___1))) uu___2 uu___1 uu___
and (resugar_bv_as_pat' :
  FStar_Syntax_DsEnv.env ->
    FStar_Syntax_Syntax.bv ->
      FStar_Parser_AST.arg_qualifier FStar_Pervasives_Native.option ->
        FStar_Syntax_Syntax.bv FStar_Compiler_FlatSet.t ->
          FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
            FStar_Pervasives_Native.option -> FStar_Parser_AST.pattern)
  =
  fun env ->
    fun v ->
      fun aqual ->
        fun body_bv ->
          fun typ_opt ->
            let mk a =
              let uu___ = FStar_Syntax_Syntax.range_of_bv v in
              FStar_Parser_AST.mk_pattern a uu___ in
            let used =
              FStar_Class_Setlike.mem ()
                (Obj.magic
                   (FStar_Compiler_FlatSet.setlike_flat_set
                      FStar_Syntax_Syntax.ord_bv)) v (Obj.magic body_bv) in
            let pat =
              let uu___ =
                if used
                then
                  let uu___1 =
                    let uu___2 = bv_as_unique_ident v in (uu___2, aqual, []) in
                  FStar_Parser_AST.PatVar uu___1
                else FStar_Parser_AST.PatWild (aqual, []) in
              mk uu___ in
            match typ_opt with
            | FStar_Pervasives_Native.None -> pat
            | FStar_Pervasives_Native.Some
                { FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_unknown;
                  FStar_Syntax_Syntax.pos = uu___;
                  FStar_Syntax_Syntax.vars = uu___1;
                  FStar_Syntax_Syntax.hash_code = uu___2;_}
                -> pat
            | FStar_Pervasives_Native.Some typ ->
                let uu___ = FStar_Options.print_bound_var_types () in
                if uu___
                then
                  let uu___1 =
                    let uu___2 =
                      let uu___3 =
                        let uu___4 = resugar_term' env typ in
                        (uu___4, FStar_Pervasives_Native.None) in
                      (pat, uu___3) in
                    FStar_Parser_AST.PatAscribed uu___2 in
                  mk uu___1
                else pat
and (resugar_bv_as_pat :
  FStar_Syntax_DsEnv.env ->
    FStar_Syntax_Syntax.bv ->
      FStar_Syntax_Syntax.binder_qualifier FStar_Pervasives_Native.option ->
        FStar_Syntax_Syntax.bv FStar_Compiler_FlatSet.t ->
          FStar_Parser_AST.pattern FStar_Pervasives_Native.option)
  =
  fun env ->
    fun x ->
      fun qual ->
        fun body_bv ->
          let uu___ = resugar_bqual env qual in
          FStar_Compiler_Util.map_opt uu___
            (fun bq ->
               let uu___1 =
                 let uu___2 =
                   FStar_Syntax_Subst.compress x.FStar_Syntax_Syntax.sort in
                 FStar_Pervasives_Native.Some uu___2 in
               resugar_bv_as_pat' env x bq body_bv uu___1)
and (resugar_pat' :
  FStar_Syntax_DsEnv.env ->
    FStar_Syntax_Syntax.pat ->
      FStar_Syntax_Syntax.bv FStar_Compiler_FlatSet.t ->
        FStar_Parser_AST.pattern)
  =
  fun env ->
    fun p ->
      fun branch_bv ->
        let mk a = FStar_Parser_AST.mk_pattern a p.FStar_Syntax_Syntax.p in
        let to_arg_qual bopt =
          FStar_Compiler_Util.bind_opt bopt
            (fun b ->
               if b
               then FStar_Pervasives_Native.Some FStar_Parser_AST.Implicit
               else FStar_Pervasives_Native.None) in
        let may_drop_implicits args =
          (let uu___ = FStar_Options.print_implicits () in
           Prims.op_Negation uu___) &&
            (let uu___ =
               FStar_Compiler_List.existsML
                 (fun uu___1 ->
                    match uu___1 with
                    | (pattern, is_implicit) ->
                        let might_be_used =
                          match pattern.FStar_Syntax_Syntax.v with
                          | FStar_Syntax_Syntax.Pat_var bv ->
                              FStar_Class_Setlike.mem ()
                                (Obj.magic
                                   (FStar_Compiler_FlatSet.setlike_flat_set
                                      FStar_Syntax_Syntax.ord_bv)) bv
                                (Obj.magic branch_bv)
                          | uu___2 -> true in
                        is_implicit && might_be_used) args in
             Prims.op_Negation uu___) in
        let resugar_plain_pat_cons' fv args =
          let uu___ =
            let uu___1 =
              let uu___2 =
                mk
                  (FStar_Parser_AST.PatName
                     ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v)) in
              (uu___2, args) in
            FStar_Parser_AST.PatApp uu___1 in
          mk uu___ in
        let rec resugar_plain_pat_cons fv args =
          let args1 =
            let uu___ = may_drop_implicits args in
            if uu___ then filter_pattern_imp args else args in
          let args2 =
            FStar_Compiler_List.map
              (fun uu___ ->
                 match uu___ with
                 | (p1, b) -> aux p1 (FStar_Pervasives_Native.Some b)) args1 in
          resugar_plain_pat_cons' fv args2
        and aux p1 imp_opt =
          match p1.FStar_Syntax_Syntax.v with
          | FStar_Syntax_Syntax.Pat_constant c ->
              mk (FStar_Parser_AST.PatConst c)
          | FStar_Syntax_Syntax.Pat_cons (fv, uu___, []) ->
              mk
                (FStar_Parser_AST.PatName
                   ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v))
          | FStar_Syntax_Syntax.Pat_cons (fv, uu___, args) when
              (FStar_Ident.lid_equals
                 (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                 FStar_Parser_Const.nil_lid)
                && (may_drop_implicits args)
              ->
              ((let uu___2 =
                  let uu___3 =
                    let uu___4 = filter_pattern_imp args in
                    FStar_Compiler_List.isEmpty uu___4 in
                  Prims.op_Negation uu___3 in
                if uu___2
                then
                  FStar_Errors.log_issue FStar_Class_HasRange.hasRange_range
                    p1.FStar_Syntax_Syntax.p
                    FStar_Errors_Codes.Warning_NilGivenExplicitArgs ()
                    (Obj.magic FStar_Errors_Msg.is_error_message_string)
                    (Obj.magic "Prims.Nil given explicit arguments")
                else ());
               mk (FStar_Parser_AST.PatList []))
          | FStar_Syntax_Syntax.Pat_cons (fv, uu___, args) when
              (FStar_Ident.lid_equals
                 (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                 FStar_Parser_Const.cons_lid)
                && (may_drop_implicits args)
              ->
              let uu___1 = filter_pattern_imp args in
              (match uu___1 with
               | (hd, false)::(tl, false)::[] ->
                   let hd' = aux hd (FStar_Pervasives_Native.Some false) in
                   let uu___2 = aux tl (FStar_Pervasives_Native.Some false) in
                   (match uu___2 with
                    | { FStar_Parser_AST.pat = FStar_Parser_AST.PatList tl';
                        FStar_Parser_AST.prange = p2;_} ->
                        FStar_Parser_AST.mk_pattern
                          (FStar_Parser_AST.PatList (hd' :: tl')) p2
                    | tl' -> resugar_plain_pat_cons' fv [hd'; tl'])
               | args' ->
                   ((let uu___3 =
                       let uu___4 =
                         FStar_Compiler_Util.string_of_int
                           (FStar_Compiler_List.length args') in
                       FStar_Compiler_Util.format1
                         "Prims.Cons applied to %s explicit arguments" uu___4 in
                     FStar_Errors.log_issue
                       FStar_Class_HasRange.hasRange_range
                       p1.FStar_Syntax_Syntax.p
                       FStar_Errors_Codes.Warning_ConsAppliedExplicitArgs ()
                       (Obj.magic FStar_Errors_Msg.is_error_message_string)
                       (Obj.magic uu___3));
                    resugar_plain_pat_cons fv args))
          | FStar_Syntax_Syntax.Pat_cons (fv, uu___, args) when
              (is_tuple_constructor_lid
                 (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v)
                && (may_drop_implicits args)
              ->
              let args1 =
                FStar_Compiler_List.filter_map
                  (fun uu___1 ->
                     match uu___1 with
                     | (p2, is_implicit) ->
                         if is_implicit
                         then FStar_Pervasives_Native.None
                         else
                           (let uu___3 =
                              aux p2 (FStar_Pervasives_Native.Some false) in
                            FStar_Pervasives_Native.Some uu___3)) args in
              let is_dependent_tuple =
                FStar_Parser_Const.is_dtuple_data_lid'
                  (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
              mk (FStar_Parser_AST.PatTuple (args1, is_dependent_tuple))
          | FStar_Syntax_Syntax.Pat_cons
              ({ FStar_Syntax_Syntax.fv_name = uu___;
                 FStar_Syntax_Syntax.fv_qual = FStar_Pervasives_Native.Some
                   (FStar_Syntax_Syntax.Record_ctor (name, fields));_},
               uu___1, args)
              ->
              let fields1 =
                let uu___2 =
                  FStar_Compiler_List.map
                    (fun f -> FStar_Ident.lid_of_ids [f]) fields in
                FStar_Compiler_List.rev uu___2 in
              let args1 =
                let uu___2 =
                  FStar_Compiler_List.map
                    (fun uu___3 ->
                       match uu___3 with
                       | (p2, b) -> aux p2 (FStar_Pervasives_Native.Some b))
                    args in
                FStar_Compiler_List.rev uu___2 in
              let rec map2 l1 l2 =
                match (l1, l2) with
                | ([], []) -> []
                | ([], hd::tl) -> []
                | (hd::tl, []) ->
                    let uu___2 =
                      let uu___3 =
                        mk
                          (FStar_Parser_AST.PatWild
                             (FStar_Pervasives_Native.None, [])) in
                      (hd, uu___3) in
                    let uu___3 = map2 tl [] in uu___2 :: uu___3
                | (hd1::tl1, hd2::tl2) ->
                    let uu___2 = map2 tl1 tl2 in (hd1, hd2) :: uu___2 in
              let args2 =
                let uu___2 = map2 fields1 args1 in
                FStar_Compiler_List.rev uu___2 in
              mk (FStar_Parser_AST.PatRecord args2)
          | FStar_Syntax_Syntax.Pat_cons (fv, uu___, args) ->
              resugar_plain_pat_cons fv args
          | FStar_Syntax_Syntax.Pat_var v ->
              let uu___ =
                let uu___1 =
                  FStar_Ident.string_of_id v.FStar_Syntax_Syntax.ppname in
                FStar_Parser_AST.string_to_op uu___1 in
              (match uu___ with
               | FStar_Pervasives_Native.Some (op, uu___1) ->
                   let uu___2 =
                     let uu___3 =
                       let uu___4 =
                         let uu___5 =
                           FStar_Ident.range_of_id
                             v.FStar_Syntax_Syntax.ppname in
                         (op, uu___5) in
                       FStar_Ident.mk_ident uu___4 in
                     FStar_Parser_AST.PatOp uu___3 in
                   mk uu___2
               | FStar_Pervasives_Native.None ->
                   let uu___1 = to_arg_qual imp_opt in
                   resugar_bv_as_pat' env v uu___1 branch_bv
                     FStar_Pervasives_Native.None)
          | FStar_Syntax_Syntax.Pat_dot_term uu___ ->
              mk
                (FStar_Parser_AST.PatWild
                   ((FStar_Pervasives_Native.Some FStar_Parser_AST.Implicit),
                     [])) in
        aux p FStar_Pervasives_Native.None
and (resugar_bqual :
  FStar_Syntax_DsEnv.env ->
    FStar_Syntax_Syntax.bqual ->
      FStar_Parser_AST.arg_qualifier FStar_Pervasives_Native.option
        FStar_Pervasives_Native.option)
  =
  fun env ->
    fun q ->
      match q with
      | FStar_Pervasives_Native.None ->
          FStar_Pervasives_Native.Some FStar_Pervasives_Native.None
      | FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Implicit b) ->
          if b
          then FStar_Pervasives_Native.None
          else
            FStar_Pervasives_Native.Some
              (FStar_Pervasives_Native.Some FStar_Parser_AST.Implicit)
      | FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Equality) ->
          FStar_Pervasives_Native.Some
            (FStar_Pervasives_Native.Some FStar_Parser_AST.Equality)
      | FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Meta t) when
          FStar_Syntax_Util.is_fvar FStar_Parser_Const.tcresolve_lid t ->
          FStar_Pervasives_Native.Some
            (FStar_Pervasives_Native.Some FStar_Parser_AST.TypeClassArg)
      | FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Meta t) ->
          let uu___ =
            let uu___1 =
              let uu___2 = resugar_term' env t in
              FStar_Parser_AST.Meta uu___2 in
            FStar_Pervasives_Native.Some uu___1 in
          FStar_Pervasives_Native.Some uu___
and (resugar_aqual :
  FStar_Syntax_DsEnv.env -> FStar_Syntax_Syntax.aqual -> FStar_Parser_AST.imp)
  =
  fun env ->
    fun q ->
      match q with
      | FStar_Pervasives_Native.None -> FStar_Parser_AST.Nothing
      | FStar_Pervasives_Native.Some a ->
          if a.FStar_Syntax_Syntax.aqual_implicit
          then FStar_Parser_AST.Hash
          else FStar_Parser_AST.Nothing
let (resugar_qualifier :
  FStar_Syntax_Syntax.qualifier ->
    FStar_Parser_AST.qualifier FStar_Pervasives_Native.option)
  =
  fun uu___ ->
    match uu___ with
    | FStar_Syntax_Syntax.Assumption ->
        FStar_Pervasives_Native.Some FStar_Parser_AST.Assumption
    | FStar_Syntax_Syntax.InternalAssumption -> FStar_Pervasives_Native.None
    | FStar_Syntax_Syntax.New ->
        FStar_Pervasives_Native.Some FStar_Parser_AST.New
    | FStar_Syntax_Syntax.Private ->
        FStar_Pervasives_Native.Some FStar_Parser_AST.Private
    | FStar_Syntax_Syntax.Unfold_for_unification_and_vcgen ->
        FStar_Pervasives_Native.Some
          FStar_Parser_AST.Unfold_for_unification_and_vcgen
    | FStar_Syntax_Syntax.Visible_default -> FStar_Pervasives_Native.None
    | FStar_Syntax_Syntax.Irreducible ->
        FStar_Pervasives_Native.Some FStar_Parser_AST.Irreducible
    | FStar_Syntax_Syntax.Inline_for_extraction ->
        FStar_Pervasives_Native.Some FStar_Parser_AST.Inline_for_extraction
    | FStar_Syntax_Syntax.NoExtract ->
        FStar_Pervasives_Native.Some FStar_Parser_AST.NoExtract
    | FStar_Syntax_Syntax.Noeq ->
        FStar_Pervasives_Native.Some FStar_Parser_AST.Noeq
    | FStar_Syntax_Syntax.Unopteq ->
        FStar_Pervasives_Native.Some FStar_Parser_AST.Unopteq
    | FStar_Syntax_Syntax.TotalEffect ->
        FStar_Pervasives_Native.Some FStar_Parser_AST.TotalEffect
    | FStar_Syntax_Syntax.Logic -> FStar_Pervasives_Native.None
    | FStar_Syntax_Syntax.Reifiable ->
        FStar_Pervasives_Native.Some FStar_Parser_AST.Reifiable
    | FStar_Syntax_Syntax.Reflectable uu___1 ->
        FStar_Pervasives_Native.Some FStar_Parser_AST.Reflectable
    | FStar_Syntax_Syntax.Discriminator uu___1 ->
        FStar_Pervasives_Native.None
    | FStar_Syntax_Syntax.Projector uu___1 -> FStar_Pervasives_Native.None
    | FStar_Syntax_Syntax.RecordType uu___1 -> FStar_Pervasives_Native.None
    | FStar_Syntax_Syntax.RecordConstructor uu___1 ->
        FStar_Pervasives_Native.None
    | FStar_Syntax_Syntax.Action uu___1 -> FStar_Pervasives_Native.None
    | FStar_Syntax_Syntax.ExceptionConstructor ->
        FStar_Pervasives_Native.None
    | FStar_Syntax_Syntax.HasMaskedEffect -> FStar_Pervasives_Native.None
    | FStar_Syntax_Syntax.Effect ->
        FStar_Pervasives_Native.Some FStar_Parser_AST.Effect_qual
    | FStar_Syntax_Syntax.OnlyName -> FStar_Pervasives_Native.None
let (resugar_pragma : FStar_Syntax_Syntax.pragma -> FStar_Parser_AST.pragma)
  =
  fun uu___ ->
    match uu___ with
    | FStar_Syntax_Syntax.SetOptions s -> FStar_Parser_AST.SetOptions s
    | FStar_Syntax_Syntax.ResetOptions s -> FStar_Parser_AST.ResetOptions s
    | FStar_Syntax_Syntax.PushOptions s -> FStar_Parser_AST.PushOptions s
    | FStar_Syntax_Syntax.PopOptions -> FStar_Parser_AST.PopOptions
    | FStar_Syntax_Syntax.RestartSolver -> FStar_Parser_AST.RestartSolver
    | FStar_Syntax_Syntax.PrintEffectsGraph ->
        FStar_Parser_AST.PrintEffectsGraph
let (resugar_typ :
  FStar_Syntax_DsEnv.env ->
    FStar_Syntax_Syntax.sigelt Prims.list ->
      FStar_Syntax_Syntax.sigelt ->
        (FStar_Syntax_Syntax.sigelts * FStar_Parser_AST.tycon))
  =
  fun env ->
    fun datacon_ses ->
      fun se ->
        match se.FStar_Syntax_Syntax.sigel with
        | FStar_Syntax_Syntax.Sig_inductive_typ
            { FStar_Syntax_Syntax.lid = tylid; FStar_Syntax_Syntax.us = uvs;
              FStar_Syntax_Syntax.params = bs;
              FStar_Syntax_Syntax.num_uniform_params = uu___;
              FStar_Syntax_Syntax.t = t;
              FStar_Syntax_Syntax.mutuals = uu___1;
              FStar_Syntax_Syntax.ds = datacons;
              FStar_Syntax_Syntax.injective_type_params = uu___2;_}
            ->
            let uu___3 =
              FStar_Compiler_List.partition
                (fun se1 ->
                   match se1.FStar_Syntax_Syntax.sigel with
                   | FStar_Syntax_Syntax.Sig_datacon
                       { FStar_Syntax_Syntax.lid1 = uu___4;
                         FStar_Syntax_Syntax.us1 = uu___5;
                         FStar_Syntax_Syntax.t1 = uu___6;
                         FStar_Syntax_Syntax.ty_lid = inductive_lid;
                         FStar_Syntax_Syntax.num_ty_params = uu___7;
                         FStar_Syntax_Syntax.mutuals1 = uu___8;
                         FStar_Syntax_Syntax.injective_type_params1 = uu___9;_}
                       -> FStar_Ident.lid_equals inductive_lid tylid
                   | uu___4 -> FStar_Compiler_Effect.failwith "unexpected")
                datacon_ses in
            (match uu___3 with
             | (current_datacons, other_datacons) ->
                 let bs1 =
                   let uu___4 = FStar_Options.print_implicits () in
                   if uu___4 then bs else filter_imp_bs bs in
                 let bs2 =
                   (map_opt ())
                     (fun b ->
                        resugar_binder' env b t.FStar_Syntax_Syntax.pos) bs1 in
                 let tyc =
                   let uu___4 =
                     FStar_Compiler_Util.for_some
                       (fun uu___5 ->
                          match uu___5 with
                          | FStar_Syntax_Syntax.RecordType uu___6 -> true
                          | uu___6 -> false) se.FStar_Syntax_Syntax.sigquals in
                   if uu___4
                   then
                     let resugar_datacon_as_fields fields se1 =
                       match se1.FStar_Syntax_Syntax.sigel with
                       | FStar_Syntax_Syntax.Sig_datacon
                           { FStar_Syntax_Syntax.lid1 = uu___5;
                             FStar_Syntax_Syntax.us1 = univs;
                             FStar_Syntax_Syntax.t1 = term;
                             FStar_Syntax_Syntax.ty_lid = uu___6;
                             FStar_Syntax_Syntax.num_ty_params = num;
                             FStar_Syntax_Syntax.mutuals1 = uu___7;
                             FStar_Syntax_Syntax.injective_type_params1 =
                               uu___8;_}
                           ->
                           let uu___9 =
                             let uu___10 = FStar_Syntax_Subst.compress term in
                             uu___10.FStar_Syntax_Syntax.n in
                           (match uu___9 with
                            | FStar_Syntax_Syntax.Tm_arrow
                                { FStar_Syntax_Syntax.bs1 = bs3;
                                  FStar_Syntax_Syntax.comp = uu___10;_}
                                ->
                                let mfields =
                                  FStar_Compiler_List.collect
                                    (fun b ->
                                       let uu___11 =
                                         resugar_bqual env
                                           b.FStar_Syntax_Syntax.binder_qual in
                                       match uu___11 with
                                       | FStar_Pervasives_Native.None -> []
                                       | FStar_Pervasives_Native.Some q ->
                                           let uu___12 =
                                             let uu___13 =
                                               bv_as_unique_ident
                                                 b.FStar_Syntax_Syntax.binder_bv in
                                             let uu___14 =
                                               FStar_Compiler_List.map
                                                 (resugar_term' env)
                                                 b.FStar_Syntax_Syntax.binder_attrs in
                                             let uu___15 =
                                               resugar_term' env
                                                 (b.FStar_Syntax_Syntax.binder_bv).FStar_Syntax_Syntax.sort in
                                             (uu___13, q, uu___14, uu___15) in
                                           [uu___12]) bs3 in
                                FStar_Compiler_List.op_At mfields fields
                            | uu___10 ->
                                FStar_Compiler_Effect.failwith "unexpected")
                       | uu___5 ->
                           FStar_Compiler_Effect.failwith "unexpected" in
                     let fields =
                       FStar_Compiler_List.fold_left
                         resugar_datacon_as_fields [] current_datacons in
                     let uu___5 =
                       let uu___6 = FStar_Ident.ident_of_lid tylid in
                       let uu___7 =
                         FStar_Compiler_List.map (resugar_term' env)
                           se.FStar_Syntax_Syntax.sigattrs in
                       (uu___6, bs2, FStar_Pervasives_Native.None, uu___7,
                         fields) in
                     FStar_Parser_AST.TyconRecord uu___5
                   else
                     (let resugar_datacon constructors se1 =
                        match se1.FStar_Syntax_Syntax.sigel with
                        | FStar_Syntax_Syntax.Sig_datacon
                            { FStar_Syntax_Syntax.lid1 = l;
                              FStar_Syntax_Syntax.us1 = univs;
                              FStar_Syntax_Syntax.t1 = term;
                              FStar_Syntax_Syntax.ty_lid = uu___6;
                              FStar_Syntax_Syntax.num_ty_params = num;
                              FStar_Syntax_Syntax.mutuals1 = uu___7;
                              FStar_Syntax_Syntax.injective_type_params1 =
                                uu___8;_}
                            ->
                            let c =
                              let uu___9 = FStar_Ident.ident_of_lid l in
                              let uu___10 =
                                let uu___11 =
                                  let uu___12 = resugar_term' env term in
                                  FStar_Parser_AST.VpArbitrary uu___12 in
                                FStar_Pervasives_Native.Some uu___11 in
                              let uu___11 =
                                FStar_Compiler_List.map (resugar_term' env)
                                  se1.FStar_Syntax_Syntax.sigattrs in
                              (uu___9, uu___10, uu___11) in
                            c :: constructors
                        | uu___6 ->
                            FStar_Compiler_Effect.failwith "unexpected" in
                      let constructors =
                        FStar_Compiler_List.fold_left resugar_datacon []
                          current_datacons in
                      let uu___6 =
                        let uu___7 = FStar_Ident.ident_of_lid tylid in
                        (uu___7, bs2, FStar_Pervasives_Native.None,
                          constructors) in
                      FStar_Parser_AST.TyconVariant uu___6) in
                 (other_datacons, tyc))
        | uu___ ->
            FStar_Compiler_Effect.failwith
              "Impossible : only Sig_inductive_typ can be resugared as types"
let (mk_decl :
  FStar_Compiler_Range_Type.range ->
    FStar_Syntax_Syntax.qualifier Prims.list ->
      FStar_Parser_AST.decl' -> FStar_Parser_AST.decl)
  =
  fun r ->
    fun q ->
      fun d' ->
        let uu___ = FStar_Compiler_List.choose resugar_qualifier q in
        {
          FStar_Parser_AST.d = d';
          FStar_Parser_AST.drange = r;
          FStar_Parser_AST.quals = uu___;
          FStar_Parser_AST.attrs = [];
          FStar_Parser_AST.interleaved = false
        }
let (decl'_to_decl :
  FStar_Syntax_Syntax.sigelt ->
    FStar_Parser_AST.decl' -> FStar_Parser_AST.decl)
  =
  fun se ->
    fun d' ->
      mk_decl se.FStar_Syntax_Syntax.sigrng se.FStar_Syntax_Syntax.sigquals
        d'
let (resugar_tscheme'' :
  FStar_Syntax_DsEnv.env ->
    Prims.string -> FStar_Syntax_Syntax.tscheme -> FStar_Parser_AST.decl)
  =
  fun env ->
    fun name ->
      fun ts ->
        let uu___ = ts in
        match uu___ with
        | (univs, typ) ->
            let name1 =
              FStar_Ident.mk_ident (name, (typ.FStar_Syntax_Syntax.pos)) in
            let uu___1 =
              let uu___2 =
                let uu___3 =
                  let uu___4 =
                    let uu___5 =
                      let uu___6 = resugar_term' env typ in
                      (name1, [], FStar_Pervasives_Native.None, uu___6) in
                    FStar_Parser_AST.TyconAbbrev uu___5 in
                  [uu___4] in
                (false, false, uu___3) in
              FStar_Parser_AST.Tycon uu___2 in
            mk_decl typ.FStar_Syntax_Syntax.pos [] uu___1
let (resugar_tscheme' :
  FStar_Syntax_DsEnv.env ->
    FStar_Syntax_Syntax.tscheme -> FStar_Parser_AST.decl)
  = fun env -> fun ts -> resugar_tscheme'' env "tscheme" ts
let (resugar_wp_eff_combinators :
  FStar_Syntax_DsEnv.env ->
    Prims.bool ->
      FStar_Syntax_Syntax.wp_eff_combinators ->
        FStar_Parser_AST.decl Prims.list)
  =
  fun env ->
    fun for_free ->
      fun combs ->
        let resugar_opt name tsopt =
          match tsopt with
          | FStar_Pervasives_Native.Some ts ->
              let uu___ = resugar_tscheme'' env name ts in [uu___]
          | FStar_Pervasives_Native.None -> [] in
        let repr = resugar_opt "repr" combs.FStar_Syntax_Syntax.repr in
        let return_repr =
          resugar_opt "return_repr" combs.FStar_Syntax_Syntax.return_repr in
        let bind_repr =
          resugar_opt "bind_repr" combs.FStar_Syntax_Syntax.bind_repr in
        if for_free
        then
          FStar_Compiler_List.op_At repr
            (FStar_Compiler_List.op_At return_repr bind_repr)
        else
          (let uu___1 =
             resugar_tscheme'' env "ret_wp" combs.FStar_Syntax_Syntax.ret_wp in
           let uu___2 =
             let uu___3 =
               resugar_tscheme'' env "bind_wp"
                 combs.FStar_Syntax_Syntax.bind_wp in
             let uu___4 =
               let uu___5 =
                 resugar_tscheme'' env "stronger"
                   combs.FStar_Syntax_Syntax.stronger in
               let uu___6 =
                 let uu___7 =
                   resugar_tscheme'' env "if_then_else"
                     combs.FStar_Syntax_Syntax.if_then_else in
                 let uu___8 =
                   let uu___9 =
                     resugar_tscheme'' env "ite_wp"
                       combs.FStar_Syntax_Syntax.ite_wp in
                   let uu___10 =
                     let uu___11 =
                       resugar_tscheme'' env "close_wp"
                         combs.FStar_Syntax_Syntax.close_wp in
                     let uu___12 =
                       let uu___13 =
                         resugar_tscheme'' env "trivial"
                           combs.FStar_Syntax_Syntax.trivial in
                       uu___13 ::
                         (FStar_Compiler_List.op_At repr
                            (FStar_Compiler_List.op_At return_repr bind_repr)) in
                     uu___11 :: uu___12 in
                   uu___9 :: uu___10 in
                 uu___7 :: uu___8 in
               uu___5 :: uu___6 in
             uu___3 :: uu___4 in
           uu___1 :: uu___2)
let (resugar_layered_eff_combinators :
  FStar_Syntax_DsEnv.env ->
    FStar_Syntax_Syntax.layered_eff_combinators ->
      FStar_Parser_AST.decl Prims.list)
  =
  fun env ->
    fun combs ->
      let resugar name uu___ =
        match uu___ with
        | (ts, uu___1, uu___2) -> resugar_tscheme'' env name ts in
      let resugar2 name uu___ =
        match uu___ with | (ts, uu___1) -> resugar_tscheme'' env name ts in
      let uu___ = resugar2 "repr" combs.FStar_Syntax_Syntax.l_repr in
      let uu___1 =
        let uu___2 = resugar2 "return" combs.FStar_Syntax_Syntax.l_return in
        let uu___3 =
          let uu___4 = resugar "bind" combs.FStar_Syntax_Syntax.l_bind in
          let uu___5 =
            let uu___6 =
              resugar "subcomp" combs.FStar_Syntax_Syntax.l_subcomp in
            let uu___7 =
              let uu___8 =
                resugar "if_then_else"
                  combs.FStar_Syntax_Syntax.l_if_then_else in
              [uu___8] in
            uu___6 :: uu___7 in
          uu___4 :: uu___5 in
        uu___2 :: uu___3 in
      uu___ :: uu___1
let (resugar_combinators :
  FStar_Syntax_DsEnv.env ->
    FStar_Syntax_Syntax.eff_combinators -> FStar_Parser_AST.decl Prims.list)
  =
  fun env ->
    fun combs ->
      match combs with
      | FStar_Syntax_Syntax.Primitive_eff combs1 ->
          resugar_wp_eff_combinators env false combs1
      | FStar_Syntax_Syntax.DM4F_eff combs1 ->
          resugar_wp_eff_combinators env true combs1
      | FStar_Syntax_Syntax.Layered_eff combs1 ->
          resugar_layered_eff_combinators env combs1
let (resugar_eff_decl' :
  FStar_Syntax_DsEnv.env ->
    FStar_Syntax_Syntax.eff_decl -> FStar_Parser_AST.decl)
  =
  fun env ->
    fun ed ->
      let r = FStar_Compiler_Range_Type.dummyRange in
      let q = [] in
      let resugar_action d for_free =
        let action_params =
          FStar_Syntax_Subst.open_binders d.FStar_Syntax_Syntax.action_params in
        let uu___ =
          FStar_Syntax_Subst.open_term action_params
            d.FStar_Syntax_Syntax.action_defn in
        match uu___ with
        | (bs, action_defn) ->
            let uu___1 =
              FStar_Syntax_Subst.open_term action_params
                d.FStar_Syntax_Syntax.action_typ in
            (match uu___1 with
             | (bs1, action_typ) ->
                 let action_params1 =
                   let uu___2 = FStar_Options.print_implicits () in
                   if uu___2
                   then action_params
                   else filter_imp_bs action_params in
                 let action_params2 =
                   let uu___2 =
                     (map_opt ()) (fun b -> resugar_binder' env b r)
                       action_params1 in
                   FStar_Compiler_List.rev uu___2 in
                 let action_defn1 = resugar_term' env action_defn in
                 let action_typ1 = resugar_term' env action_typ in
                 if for_free
                 then
                   let a =
                     let uu___2 =
                       let uu___3 = FStar_Ident.lid_of_str "construct" in
                       (uu___3,
                         [(action_defn1, FStar_Parser_AST.Nothing);
                         (action_typ1, FStar_Parser_AST.Nothing)]) in
                     FStar_Parser_AST.Construct uu___2 in
                   let t = FStar_Parser_AST.mk_term a r FStar_Parser_AST.Un in
                   let uu___2 =
                     let uu___3 =
                       let uu___4 =
                         let uu___5 =
                           let uu___6 =
                             let uu___7 =
                               FStar_Ident.ident_of_lid
                                 d.FStar_Syntax_Syntax.action_name in
                             (uu___7, action_params2,
                               FStar_Pervasives_Native.None, t) in
                           FStar_Parser_AST.TyconAbbrev uu___6 in
                         [uu___5] in
                       (false, false, uu___4) in
                     FStar_Parser_AST.Tycon uu___3 in
                   mk_decl r q uu___2
                 else
                   (let uu___3 =
                      let uu___4 =
                        let uu___5 =
                          let uu___6 =
                            let uu___7 =
                              let uu___8 =
                                FStar_Ident.ident_of_lid
                                  d.FStar_Syntax_Syntax.action_name in
                              (uu___8, action_params2,
                                FStar_Pervasives_Native.None, action_defn1) in
                            FStar_Parser_AST.TyconAbbrev uu___7 in
                          [uu___6] in
                        (false, false, uu___5) in
                      FStar_Parser_AST.Tycon uu___4 in
                    mk_decl r q uu___3)) in
      let eff_name = FStar_Ident.ident_of_lid ed.FStar_Syntax_Syntax.mname in
      let uu___ =
        let sig_ts =
          FStar_Syntax_Util.effect_sig_ts ed.FStar_Syntax_Syntax.signature in
        FStar_Syntax_Subst.open_term ed.FStar_Syntax_Syntax.binders
          (FStar_Pervasives_Native.snd sig_ts) in
      match uu___ with
      | (eff_binders, eff_typ) ->
          let eff_binders1 =
            let uu___1 = FStar_Options.print_implicits () in
            if uu___1 then eff_binders else filter_imp_bs eff_binders in
          let eff_binders2 =
            let uu___1 =
              (map_opt ()) (fun b -> resugar_binder' env b r) eff_binders1 in
            FStar_Compiler_List.rev uu___1 in
          let eff_typ1 = resugar_term' env eff_typ in
          let mandatory_members_decls =
            resugar_combinators env ed.FStar_Syntax_Syntax.combinators in
          let actions =
            FStar_Compiler_List.map (fun a -> resugar_action a false)
              ed.FStar_Syntax_Syntax.actions in
          let decls =
            FStar_Compiler_List.op_At mandatory_members_decls actions in
          mk_decl r q
            (FStar_Parser_AST.NewEffect
               (FStar_Parser_AST.DefineEffect
                  (eff_name, eff_binders2, eff_typ1, decls)))
let (resugar_sigelt' :
  FStar_Syntax_DsEnv.env ->
    FStar_Syntax_Syntax.sigelt ->
      FStar_Parser_AST.decl FStar_Pervasives_Native.option)
  =
  fun env ->
    fun se ->
      match se.FStar_Syntax_Syntax.sigel with
      | FStar_Syntax_Syntax.Sig_bundle
          { FStar_Syntax_Syntax.ses = ses;
            FStar_Syntax_Syntax.lids = uu___;_}
          ->
          let uu___1 =
            FStar_Compiler_List.partition
              (fun se1 ->
                 match se1.FStar_Syntax_Syntax.sigel with
                 | FStar_Syntax_Syntax.Sig_inductive_typ uu___2 -> true
                 | FStar_Syntax_Syntax.Sig_declare_typ uu___2 -> true
                 | FStar_Syntax_Syntax.Sig_datacon uu___2 -> false
                 | uu___2 ->
                     FStar_Compiler_Effect.failwith
                       "Found a sigelt which is neither a type declaration or a data constructor in a sigelt")
              ses in
          (match uu___1 with
           | (decl_typ_ses, datacon_ses) ->
               let retrieve_datacons_and_resugar uu___2 se1 =
                 match uu___2 with
                 | (datacon_ses1, tycons) ->
                     let uu___3 = resugar_typ env datacon_ses1 se1 in
                     (match uu___3 with
                      | (datacon_ses2, tyc) ->
                          (datacon_ses2, (tyc :: tycons))) in
               let uu___2 =
                 FStar_Compiler_List.fold_left retrieve_datacons_and_resugar
                   (datacon_ses, []) decl_typ_ses in
               (match uu___2 with
                | (leftover_datacons, tycons) ->
                    (match leftover_datacons with
                     | [] ->
                         let uu___3 =
                           decl'_to_decl se
                             (FStar_Parser_AST.Tycon (false, false, tycons)) in
                         FStar_Pervasives_Native.Some uu___3
                     | se1::[] ->
                         (match se1.FStar_Syntax_Syntax.sigel with
                          | FStar_Syntax_Syntax.Sig_datacon
                              { FStar_Syntax_Syntax.lid1 = l;
                                FStar_Syntax_Syntax.us1 = uu___3;
                                FStar_Syntax_Syntax.t1 = uu___4;
                                FStar_Syntax_Syntax.ty_lid = uu___5;
                                FStar_Syntax_Syntax.num_ty_params = uu___6;
                                FStar_Syntax_Syntax.mutuals1 = uu___7;
                                FStar_Syntax_Syntax.injective_type_params1 =
                                  uu___8;_}
                              ->
                              let uu___9 =
                                let uu___10 =
                                  let uu___11 =
                                    let uu___12 = FStar_Ident.ident_of_lid l in
                                    (uu___12, FStar_Pervasives_Native.None) in
                                  FStar_Parser_AST.Exception uu___11 in
                                decl'_to_decl se1 uu___10 in
                              FStar_Pervasives_Native.Some uu___9
                          | uu___3 ->
                              FStar_Compiler_Effect.failwith
                                "wrong format for resguar to Exception")
                     | uu___3 ->
                         FStar_Compiler_Effect.failwith
                           "Should not happen hopefully")))
      | FStar_Syntax_Syntax.Sig_fail uu___ -> FStar_Pervasives_Native.None
      | FStar_Syntax_Syntax.Sig_let
          { FStar_Syntax_Syntax.lbs1 = lbs;
            FStar_Syntax_Syntax.lids1 = uu___;_}
          ->
          let uu___1 =
            FStar_Compiler_Util.for_some
              (fun uu___2 ->
                 match uu___2 with
                 | FStar_Syntax_Syntax.Projector (uu___3, uu___4) -> true
                 | FStar_Syntax_Syntax.Discriminator uu___3 -> true
                 | uu___3 -> false) se.FStar_Syntax_Syntax.sigquals in
          if uu___1
          then FStar_Pervasives_Native.None
          else
            (let mk e =
               FStar_Syntax_Syntax.mk e se.FStar_Syntax_Syntax.sigrng in
             let dummy = mk FStar_Syntax_Syntax.Tm_unknown in
             let nopath_lbs uu___3 =
               match uu___3 with
               | (is_rec, lbs1) ->
                   let nopath fv =
                     let uu___4 =
                       let uu___5 =
                         let uu___6 =
                           let uu___7 = FStar_Syntax_Syntax.lid_of_fv fv in
                           FStar_Ident.ident_of_lid uu___7 in
                         [uu___6] in
                       FStar_Ident.lid_of_ids uu___5 in
                     FStar_Syntax_Syntax.lid_as_fv uu___4
                       FStar_Pervasives_Native.None in
                   let lbs2 =
                     FStar_Compiler_List.map
                       (fun lb ->
                          let uu___4 =
                            let uu___5 =
                              let uu___6 =
                                FStar_Compiler_Util.right
                                  lb.FStar_Syntax_Syntax.lbname in
                              nopath uu___6 in
                            FStar_Pervasives.Inr uu___5 in
                          {
                            FStar_Syntax_Syntax.lbname = uu___4;
                            FStar_Syntax_Syntax.lbunivs =
                              (lb.FStar_Syntax_Syntax.lbunivs);
                            FStar_Syntax_Syntax.lbtyp =
                              (lb.FStar_Syntax_Syntax.lbtyp);
                            FStar_Syntax_Syntax.lbeff =
                              (lb.FStar_Syntax_Syntax.lbeff);
                            FStar_Syntax_Syntax.lbdef =
                              (lb.FStar_Syntax_Syntax.lbdef);
                            FStar_Syntax_Syntax.lbattrs =
                              (lb.FStar_Syntax_Syntax.lbattrs);
                            FStar_Syntax_Syntax.lbpos =
                              (lb.FStar_Syntax_Syntax.lbpos)
                          }) lbs1 in
                   (is_rec, lbs2) in
             let lbs1 = nopath_lbs lbs in
             let desugared_let =
               mk
                 (FStar_Syntax_Syntax.Tm_let
                    {
                      FStar_Syntax_Syntax.lbs = lbs1;
                      FStar_Syntax_Syntax.body1 = dummy
                    }) in
             let t = resugar_term' env desugared_let in
             match t.FStar_Parser_AST.tm with
             | FStar_Parser_AST.Let (isrec, lets, uu___3) ->
                 let uu___4 =
                   let uu___5 =
                     let uu___6 =
                       let uu___7 =
                         FStar_Compiler_List.map FStar_Pervasives_Native.snd
                           lets in
                       (isrec, uu___7) in
                     FStar_Parser_AST.TopLevelLet uu___6 in
                   decl'_to_decl se uu___5 in
                 FStar_Pervasives_Native.Some uu___4
             | uu___3 ->
                 FStar_Compiler_Effect.failwith "Should not happen hopefully")
      | FStar_Syntax_Syntax.Sig_assume
          { FStar_Syntax_Syntax.lid3 = lid; FStar_Syntax_Syntax.us3 = uu___;
            FStar_Syntax_Syntax.phi1 = fml;_}
          ->
          let uu___1 =
            let uu___2 =
              let uu___3 =
                let uu___4 = FStar_Ident.ident_of_lid lid in
                let uu___5 = resugar_term' env fml in (uu___4, uu___5) in
              FStar_Parser_AST.Assume uu___3 in
            decl'_to_decl se uu___2 in
          FStar_Pervasives_Native.Some uu___1
      | FStar_Syntax_Syntax.Sig_new_effect ed ->
          let a_decl = resugar_eff_decl' env ed in
          let q =
            FStar_Compiler_List.choose resugar_qualifier
              se.FStar_Syntax_Syntax.sigquals in
          FStar_Pervasives_Native.Some
            {
              FStar_Parser_AST.d = (a_decl.FStar_Parser_AST.d);
              FStar_Parser_AST.drange = (a_decl.FStar_Parser_AST.drange);
              FStar_Parser_AST.quals = q;
              FStar_Parser_AST.attrs = (a_decl.FStar_Parser_AST.attrs);
              FStar_Parser_AST.interleaved =
                (a_decl.FStar_Parser_AST.interleaved)
            }
      | FStar_Syntax_Syntax.Sig_sub_effect e ->
          let src = e.FStar_Syntax_Syntax.source in
          let dst = e.FStar_Syntax_Syntax.target in
          let lift_wp =
            match e.FStar_Syntax_Syntax.lift_wp with
            | FStar_Pervasives_Native.Some (uu___, t) ->
                let uu___1 = resugar_term' env t in
                FStar_Pervasives_Native.Some uu___1
            | uu___ -> FStar_Pervasives_Native.None in
          let lift =
            match e.FStar_Syntax_Syntax.lift with
            | FStar_Pervasives_Native.Some (uu___, t) ->
                let uu___1 = resugar_term' env t in
                FStar_Pervasives_Native.Some uu___1
            | uu___ -> FStar_Pervasives_Native.None in
          let op =
            match (lift_wp, lift) with
            | (FStar_Pervasives_Native.Some t, FStar_Pervasives_Native.None)
                -> FStar_Parser_AST.NonReifiableLift t
            | (FStar_Pervasives_Native.Some wp, FStar_Pervasives_Native.Some
               t) -> FStar_Parser_AST.ReifiableLift (wp, t)
            | (FStar_Pervasives_Native.None, FStar_Pervasives_Native.Some t)
                -> FStar_Parser_AST.LiftForFree t
            | uu___ ->
                FStar_Compiler_Effect.failwith "Should not happen hopefully" in
          let uu___ =
            decl'_to_decl se
              (FStar_Parser_AST.SubEffect
                 {
                   FStar_Parser_AST.msource = src;
                   FStar_Parser_AST.mdest = dst;
                   FStar_Parser_AST.lift_op = op;
                   FStar_Parser_AST.braced = false
                 }) in
          FStar_Pervasives_Native.Some uu___
      | FStar_Syntax_Syntax.Sig_effect_abbrev
          { FStar_Syntax_Syntax.lid4 = lid; FStar_Syntax_Syntax.us4 = vs;
            FStar_Syntax_Syntax.bs2 = bs; FStar_Syntax_Syntax.comp1 = c;
            FStar_Syntax_Syntax.cflags = flags;_}
          ->
          let uu___ = FStar_Syntax_Subst.open_comp bs c in
          (match uu___ with
           | (bs1, c1) ->
               let bs2 =
                 let uu___1 = FStar_Options.print_implicits () in
                 if uu___1 then bs1 else filter_imp_bs bs1 in
               let bs3 =
                 (map_opt ())
                   (fun b ->
                      resugar_binder' env b se.FStar_Syntax_Syntax.sigrng)
                   bs2 in
               let uu___1 =
                 let uu___2 =
                   let uu___3 =
                     let uu___4 =
                       let uu___5 =
                         let uu___6 =
                           let uu___7 = FStar_Ident.ident_of_lid lid in
                           let uu___8 = resugar_comp' env c1 in
                           (uu___7, bs3, FStar_Pervasives_Native.None,
                             uu___8) in
                         FStar_Parser_AST.TyconAbbrev uu___6 in
                       [uu___5] in
                     (false, false, uu___4) in
                   FStar_Parser_AST.Tycon uu___3 in
                 decl'_to_decl se uu___2 in
               FStar_Pervasives_Native.Some uu___1)
      | FStar_Syntax_Syntax.Sig_pragma p ->
          let uu___ =
            decl'_to_decl se (FStar_Parser_AST.Pragma (resugar_pragma p)) in
          FStar_Pervasives_Native.Some uu___
      | FStar_Syntax_Syntax.Sig_declare_typ
          { FStar_Syntax_Syntax.lid2 = lid; FStar_Syntax_Syntax.us2 = uvs;
            FStar_Syntax_Syntax.t2 = t;_}
          ->
          let uu___ =
            FStar_Compiler_Util.for_some
              (fun uu___1 ->
                 match uu___1 with
                 | FStar_Syntax_Syntax.Projector (uu___2, uu___3) -> true
                 | FStar_Syntax_Syntax.Discriminator uu___2 -> true
                 | uu___2 -> false) se.FStar_Syntax_Syntax.sigquals in
          if uu___
          then FStar_Pervasives_Native.None
          else
            (let t' =
               let uu___2 =
                 (let uu___3 = FStar_Options.print_universes () in
                  Prims.op_Negation uu___3) ||
                   (FStar_Compiler_List.isEmpty uvs) in
               if uu___2
               then resugar_term' env t
               else
                 (let uu___4 = FStar_Syntax_Subst.open_univ_vars uvs t in
                  match uu___4 with
                  | (uvs1, t1) ->
                      let universes = universe_to_string uvs1 in
                      let uu___5 = resugar_term' env t1 in
                      label universes uu___5) in
             let uu___2 =
               let uu___3 =
                 let uu___4 =
                   let uu___5 = FStar_Ident.ident_of_lid lid in (uu___5, t') in
                 FStar_Parser_AST.Val uu___4 in
               decl'_to_decl se uu___3 in
             FStar_Pervasives_Native.Some uu___2)
      | FStar_Syntax_Syntax.Sig_splice
          { FStar_Syntax_Syntax.is_typed = is_typed;
            FStar_Syntax_Syntax.lids2 = ids; FStar_Syntax_Syntax.tac = t;_}
          ->
          let uu___ =
            let uu___1 =
              let uu___2 =
                let uu___3 =
                  FStar_Compiler_List.map
                    (fun l -> FStar_Ident.ident_of_lid l) ids in
                let uu___4 = resugar_term' env t in
                (is_typed, uu___3, uu___4) in
              FStar_Parser_AST.Splice uu___2 in
            decl'_to_decl se uu___1 in
          FStar_Pervasives_Native.Some uu___
      | FStar_Syntax_Syntax.Sig_inductive_typ uu___ ->
          FStar_Pervasives_Native.None
      | FStar_Syntax_Syntax.Sig_datacon uu___ -> FStar_Pervasives_Native.None
      | FStar_Syntax_Syntax.Sig_polymonadic_bind
          { FStar_Syntax_Syntax.m_lid = m; FStar_Syntax_Syntax.n_lid = n;
            FStar_Syntax_Syntax.p_lid = p;
            FStar_Syntax_Syntax.tm3 = (uu___, t);
            FStar_Syntax_Syntax.typ = uu___1;
            FStar_Syntax_Syntax.kind1 = uu___2;_}
          ->
          let uu___3 =
            let uu___4 =
              let uu___5 =
                let uu___6 = resugar_term' env t in (m, n, p, uu___6) in
              FStar_Parser_AST.Polymonadic_bind uu___5 in
            decl'_to_decl se uu___4 in
          FStar_Pervasives_Native.Some uu___3
      | FStar_Syntax_Syntax.Sig_polymonadic_subcomp
          { FStar_Syntax_Syntax.m_lid1 = m; FStar_Syntax_Syntax.n_lid1 = n;
            FStar_Syntax_Syntax.tm4 = (uu___, t);
            FStar_Syntax_Syntax.typ1 = uu___1;
            FStar_Syntax_Syntax.kind2 = uu___2;_}
          ->
          let uu___3 =
            let uu___4 =
              let uu___5 = let uu___6 = resugar_term' env t in (m, n, uu___6) in
              FStar_Parser_AST.Polymonadic_subcomp uu___5 in
            decl'_to_decl se uu___4 in
          FStar_Pervasives_Native.Some uu___3
let (empty_env : FStar_Syntax_DsEnv.env) =
  FStar_Syntax_DsEnv.empty_env FStar_Parser_Dep.empty_deps
let noenv : 'a . (FStar_Syntax_DsEnv.env -> 'a) -> 'a = fun f -> f empty_env
let (resugar_term : FStar_Syntax_Syntax.term -> FStar_Parser_AST.term) =
  fun t -> let uu___ = noenv resugar_term' in uu___ t
let (resugar_sigelt :
  FStar_Syntax_Syntax.sigelt ->
    FStar_Parser_AST.decl FStar_Pervasives_Native.option)
  = fun se -> let uu___ = noenv resugar_sigelt' in uu___ se
let (resugar_comp : FStar_Syntax_Syntax.comp -> FStar_Parser_AST.term) =
  fun c -> let uu___ = noenv resugar_comp' in uu___ c
let (resugar_pat :
  FStar_Syntax_Syntax.pat ->
    FStar_Syntax_Syntax.bv FStar_Compiler_FlatSet.t ->
      FStar_Parser_AST.pattern)
  =
  fun p ->
    fun branch_bv -> let uu___ = noenv resugar_pat' in uu___ p branch_bv
let (resugar_binder :
  FStar_Syntax_Syntax.binder ->
    FStar_Compiler_Range_Type.range ->
      FStar_Parser_AST.binder FStar_Pervasives_Native.option)
  = fun b -> fun r -> let uu___ = noenv resugar_binder' in uu___ b r
let (resugar_tscheme : FStar_Syntax_Syntax.tscheme -> FStar_Parser_AST.decl)
  = fun ts -> let uu___ = noenv resugar_tscheme' in uu___ ts
let (resugar_eff_decl :
  FStar_Syntax_Syntax.eff_decl -> FStar_Parser_AST.decl) =
  fun ed -> let uu___ = noenv resugar_eff_decl' in uu___ ed