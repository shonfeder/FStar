open Prims
type using_facts_from_setting =
  (Prims.string Prims.list * Prims.bool) Prims.list
type decl_name_set = Prims.bool FStar_Compiler_Util.psmap
let (empty_decl_names : Prims.bool FStar_Compiler_Util.psmap) =
  FStar_Compiler_Util.psmap_empty ()
let (decl_names_contains : Prims.string -> decl_name_set -> Prims.bool) =
  fun x ->
    fun s ->
      let uu___ = FStar_Compiler_Util.psmap_try_find s x in
      FStar_Pervasives_Native.uu___is_Some uu___
let (add_name :
  Prims.string -> decl_name_set -> Prims.bool FStar_Compiler_Util.psmap) =
  fun x -> fun s -> FStar_Compiler_Util.psmap_add s x true
type decls_at_level =
  {
  pruning_state: FStar_SMTEncoding_Pruning.pruning_state ;
  given_decl_names: decl_name_set ;
  all_decls_at_level_rev: FStar_SMTEncoding_Term.decl Prims.list Prims.list ;
  given_some_decls: Prims.bool ;
  to_flush_rev: FStar_SMTEncoding_Term.decl Prims.list Prims.list ;
  named_assumptions:
    FStar_SMTEncoding_Term.assumption FStar_Compiler_Util.psmap }
let (__proj__Mkdecls_at_level__item__pruning_state :
  decls_at_level -> FStar_SMTEncoding_Pruning.pruning_state) =
  fun projectee ->
    match projectee with
    | { pruning_state; given_decl_names; all_decls_at_level_rev;
        given_some_decls; to_flush_rev; named_assumptions;_} -> pruning_state
let (__proj__Mkdecls_at_level__item__given_decl_names :
  decls_at_level -> decl_name_set) =
  fun projectee ->
    match projectee with
    | { pruning_state; given_decl_names; all_decls_at_level_rev;
        given_some_decls; to_flush_rev; named_assumptions;_} ->
        given_decl_names
let (__proj__Mkdecls_at_level__item__all_decls_at_level_rev :
  decls_at_level -> FStar_SMTEncoding_Term.decl Prims.list Prims.list) =
  fun projectee ->
    match projectee with
    | { pruning_state; given_decl_names; all_decls_at_level_rev;
        given_some_decls; to_flush_rev; named_assumptions;_} ->
        all_decls_at_level_rev
let (__proj__Mkdecls_at_level__item__given_some_decls :
  decls_at_level -> Prims.bool) =
  fun projectee ->
    match projectee with
    | { pruning_state; given_decl_names; all_decls_at_level_rev;
        given_some_decls; to_flush_rev; named_assumptions;_} ->
        given_some_decls
let (__proj__Mkdecls_at_level__item__to_flush_rev :
  decls_at_level -> FStar_SMTEncoding_Term.decl Prims.list Prims.list) =
  fun projectee ->
    match projectee with
    | { pruning_state; given_decl_names; all_decls_at_level_rev;
        given_some_decls; to_flush_rev; named_assumptions;_} -> to_flush_rev
let (__proj__Mkdecls_at_level__item__named_assumptions :
  decls_at_level ->
    FStar_SMTEncoding_Term.assumption FStar_Compiler_Util.psmap)
  =
  fun projectee ->
    match projectee with
    | { pruning_state; given_decl_names; all_decls_at_level_rev;
        given_some_decls; to_flush_rev; named_assumptions;_} ->
        named_assumptions
let (init_given_decls_at_level : decls_at_level) =
  let uu___ = FStar_Compiler_Util.psmap_empty () in
  {
    pruning_state = FStar_SMTEncoding_Pruning.init;
    given_decl_names = empty_decl_names;
    all_decls_at_level_rev = [];
    given_some_decls = false;
    to_flush_rev = [];
    named_assumptions = uu___
  }
type solver_state =
  {
  levels: decls_at_level Prims.list ;
  pending_flushes_rev: FStar_SMTEncoding_Term.decl Prims.list ;
  using_facts_from: using_facts_from_setting FStar_Pervasives_Native.option ;
  prune_sim: Prims.string Prims.list FStar_Pervasives_Native.option }
let (__proj__Mksolver_state__item__levels :
  solver_state -> decls_at_level Prims.list) =
  fun projectee ->
    match projectee with
    | { levels; pending_flushes_rev; using_facts_from; prune_sim;_} -> levels
let (__proj__Mksolver_state__item__pending_flushes_rev :
  solver_state -> FStar_SMTEncoding_Term.decl Prims.list) =
  fun projectee ->
    match projectee with
    | { levels; pending_flushes_rev; using_facts_from; prune_sim;_} ->
        pending_flushes_rev
let (__proj__Mksolver_state__item__using_facts_from :
  solver_state -> using_facts_from_setting FStar_Pervasives_Native.option) =
  fun projectee ->
    match projectee with
    | { levels; pending_flushes_rev; using_facts_from; prune_sim;_} ->
        using_facts_from
let (__proj__Mksolver_state__item__prune_sim :
  solver_state -> Prims.string Prims.list FStar_Pervasives_Native.option) =
  fun projectee ->
    match projectee with
    | { levels; pending_flushes_rev; using_facts_from; prune_sim;_} ->
        prune_sim
let (solver_state_to_string : solver_state -> Prims.string) =
  fun s ->
    let levels =
      FStar_Compiler_List.map
        (fun level ->
           let uu___ =
             FStar_Class_Show.show
               (FStar_Class_Show.printableshow
                  FStar_Class_Printable.printable_nat)
               (FStar_Compiler_List.length level.all_decls_at_level_rev) in
           let uu___1 =
             FStar_Class_Show.show
               (FStar_Class_Show.printableshow
                  FStar_Class_Printable.printable_bool)
               level.given_some_decls in
           let uu___2 =
             FStar_Class_Show.show
               (FStar_Class_Show.printableshow
                  FStar_Class_Printable.printable_nat)
               (FStar_Compiler_List.length level.to_flush_rev) in
           FStar_Compiler_Util.format3
             "Level { all_decls=%s; given_decls=%s; to_flush=%s }" uu___
             uu___1 uu___2) s.levels in
    let uu___ =
      FStar_Class_Show.show
        (FStar_Class_Show.show_list
           (FStar_Class_Show.printableshow
              FStar_Class_Printable.printable_string)) levels in
    let uu___1 =
      FStar_Class_Show.show
        (FStar_Class_Show.printableshow FStar_Class_Printable.printable_nat)
        (FStar_Compiler_List.length s.pending_flushes_rev) in
    FStar_Compiler_Util.format2
      "Solver state { levels=%s; pending_flushes=%s }" uu___ uu___1
let (debug : Prims.string -> solver_state -> solver_state -> unit) =
  fun msg ->
    fun s0 ->
      fun s1 ->
        let uu___ =
          let uu___1 = FStar_Options.ext_getv "debug_solver_state" in
          uu___1 <> "" in
        if uu___
        then
          let uu___1 = solver_state_to_string s0 in
          let uu___2 = solver_state_to_string s1 in
          FStar_Compiler_Util.print3
            "Debug (%s):{\n\t before=%s\n\t after=%s\n}" msg uu___1 uu___2
        else ()
let (peek : solver_state -> (decls_at_level * decls_at_level Prims.list)) =
  fun s ->
    match s.levels with
    | [] ->
        FStar_Compiler_Effect.failwith
          "Solver state cannot have an empty stack"
    | hd::tl -> (hd, tl)
let (init : unit -> solver_state) =
  fun uu___ ->
    let uu___1 =
      let uu___2 = FStar_Options.using_facts_from () in
      FStar_Pervasives_Native.Some uu___2 in
    {
      levels = [init_given_decls_at_level];
      pending_flushes_rev = [];
      using_facts_from = uu___1;
      prune_sim = FStar_Pervasives_Native.None
    }
let (push : solver_state -> solver_state) =
  fun s ->
    let uu___ = peek s in
    match uu___ with
    | (hd, uu___1) ->
        let push1 =
          FStar_SMTEncoding_Term.Push (FStar_Compiler_List.length s.levels) in
        let next =
          {
            pruning_state = (hd.pruning_state);
            given_decl_names = (hd.given_decl_names);
            all_decls_at_level_rev = [];
            given_some_decls = false;
            to_flush_rev = [[push1]];
            named_assumptions = (hd.named_assumptions)
          } in
        let s1 =
          {
            levels = (next :: (s.levels));
            pending_flushes_rev = (s.pending_flushes_rev);
            using_facts_from = (s.using_facts_from);
            prune_sim = (s.prune_sim)
          } in
        (debug "push" s s1; s1)
let (pop : solver_state -> solver_state) =
  fun s ->
    let uu___ = peek s in
    match uu___ with
    | (hd, tl) ->
        (if Prims.uu___is_Nil tl
         then
           FStar_Compiler_Effect.failwith
             "Solver state cannot have an empty stack"
         else ();
         (let s1 =
            if Prims.op_Negation hd.given_some_decls
            then
              {
                levels = tl;
                pending_flushes_rev = (s.pending_flushes_rev);
                using_facts_from = (s.using_facts_from);
                prune_sim = (s.prune_sim)
              }
            else
              {
                levels = tl;
                pending_flushes_rev =
                  ((FStar_SMTEncoding_Term.Pop
                      (FStar_Compiler_List.length tl)) ::
                  (s.pending_flushes_rev));
                using_facts_from = (s.using_facts_from);
                prune_sim = (s.prune_sim)
              } in
          debug "pop" s s1; s1))
let (filter_using_facts_from :
  using_facts_from_setting FStar_Pervasives_Native.option ->
    FStar_SMTEncoding_Term.assumption FStar_Compiler_Util.psmap ->
      solver_state ->
        FStar_SMTEncoding_Term.decl Prims.list ->
          FStar_SMTEncoding_Term.decl Prims.list)
  =
  fun using_facts_from ->
    fun named_assumptions ->
      fun s ->
        fun ds ->
          match using_facts_from with
          | FStar_Pervasives_Native.None -> ds
          | FStar_Pervasives_Native.Some (([], true)::[]) -> ds
          | FStar_Pervasives_Native.Some using_facts_from1 ->
              let keep_assumption a =
                match a.FStar_SMTEncoding_Term.assumption_fact_ids with
                | [] -> true
                | uu___ ->
                    FStar_Compiler_Util.for_some
                      (fun uu___1 ->
                         match uu___1 with
                         | FStar_SMTEncoding_Term.Name lid ->
                             FStar_TypeChecker_Env.should_enc_lid
                               using_facts_from1 lid
                         | uu___2 -> false)
                      a.FStar_SMTEncoding_Term.assumption_fact_ids in
              let already_given_map =
                FStar_Compiler_Util.smap_create (Prims.of_int (1000)) in
              let add_assumption a =
                FStar_Compiler_Util.smap_add already_given_map
                  a.FStar_SMTEncoding_Term.assumption_name true in
              let already_given a =
                (let uu___ =
                   FStar_Compiler_Util.smap_try_find already_given_map
                     a.FStar_SMTEncoding_Term.assumption_name in
                 FStar_Pervasives_Native.uu___is_Some uu___) ||
                  (FStar_Compiler_Util.for_some
                     (fun level ->
                        decl_names_contains
                          a.FStar_SMTEncoding_Term.assumption_name
                          level.given_decl_names) s.levels) in
              let map_decl d =
                match d with
                | FStar_SMTEncoding_Term.Assume a ->
                    let uu___ =
                      (keep_assumption a) &&
                        (let uu___1 = already_given a in
                         Prims.op_Negation uu___1) in
                    if uu___ then (add_assumption a; [d]) else []
                | FStar_SMTEncoding_Term.RetainAssumptions names ->
                    let assumptions =
                      FStar_Compiler_List.collect
                        (fun name ->
                           let uu___ =
                             FStar_Compiler_Util.psmap_try_find
                               named_assumptions name in
                           match uu___ with
                           | FStar_Pervasives_Native.None -> []
                           | FStar_Pervasives_Native.Some a ->
                               let uu___1 = already_given a in
                               if uu___1
                               then []
                               else
                                 (add_assumption a;
                                  [FStar_SMTEncoding_Term.Assume a])) names in
                    assumptions
                | uu___ -> [d] in
              let ds1 = FStar_Compiler_List.collect map_decl ds in ds1
let rec (flatten :
  FStar_SMTEncoding_Term.decl -> FStar_SMTEncoding_Term.decl Prims.list) =
  fun d ->
    match d with
    | FStar_SMTEncoding_Term.Module (uu___, ds) ->
        FStar_Compiler_List.collect flatten ds
    | uu___ -> [d]
let (add_named_assumptions :
  FStar_SMTEncoding_Term.assumption FStar_Compiler_Util.psmap ->
    FStar_SMTEncoding_Term.decl Prims.list ->
      FStar_SMTEncoding_Term.assumption FStar_Compiler_Util.psmap)
  =
  fun named_assumptions ->
    fun ds ->
      FStar_Compiler_List.fold_left
        (fun named_assumptions1 ->
           fun d ->
             match d with
             | FStar_SMTEncoding_Term.Assume a ->
                 FStar_Compiler_Util.psmap_add named_assumptions1
                   a.FStar_SMTEncoding_Term.assumption_name a
             | uu___ -> named_assumptions1) named_assumptions ds
let (give_delay_assumptions :
  FStar_SMTEncoding_Term.decl Prims.list -> solver_state -> solver_state) =
  fun ds ->
    fun s ->
      let decls = FStar_Compiler_List.collect flatten ds in
      let uu___ =
        FStar_Compiler_List.partition FStar_SMTEncoding_Term.uu___is_Assume
          decls in
      match uu___ with
      | (assumptions, rest) ->
          let uu___1 = peek s in
          (match uu___1 with
           | (hd, tl) ->
               let hd1 =
                 let uu___2 =
                   FStar_SMTEncoding_Pruning.add_decls decls hd.pruning_state in
                 let uu___3 =
                   add_named_assumptions hd.named_assumptions assumptions in
                 {
                   pruning_state = uu___2;
                   given_decl_names = (hd.given_decl_names);
                   all_decls_at_level_rev = (ds ::
                     (hd.all_decls_at_level_rev));
                   given_some_decls = (hd.given_some_decls);
                   to_flush_rev = (rest :: (hd.to_flush_rev));
                   named_assumptions = uu___3
                 } in
               {
                 levels = (hd1 :: tl);
                 pending_flushes_rev = (s.pending_flushes_rev);
                 using_facts_from = (s.using_facts_from);
                 prune_sim = (s.prune_sim)
               })
let (give_now :
  FStar_SMTEncoding_Term.decl Prims.list -> solver_state -> solver_state) =
  fun ds ->
    fun s ->
      let decls = FStar_Compiler_List.collect flatten ds in
      let uu___ =
        FStar_Compiler_List.partition FStar_SMTEncoding_Term.uu___is_Assume
          decls in
      match uu___ with
      | (assumptions, uu___1) ->
          let uu___2 = peek s in
          (match uu___2 with
           | (hd, tl) ->
               let named_assumptions =
                 add_named_assumptions hd.named_assumptions assumptions in
               let ds_to_flush =
                 filter_using_facts_from s.using_facts_from named_assumptions
                   s decls in
               let given =
                 FStar_Compiler_List.fold_left
                   (fun given1 ->
                      fun d ->
                        match d with
                        | FStar_SMTEncoding_Term.Assume a ->
                            add_name a.FStar_SMTEncoding_Term.assumption_name
                              given1
                        | uu___3 -> given1) hd.given_decl_names ds_to_flush in
               let hd1 =
                 let uu___3 =
                   FStar_SMTEncoding_Pruning.add_decls decls hd.pruning_state in
                 {
                   pruning_state = uu___3;
                   given_decl_names = given;
                   all_decls_at_level_rev = (ds ::
                     (hd.all_decls_at_level_rev));
                   given_some_decls = (hd.given_some_decls);
                   to_flush_rev = (ds_to_flush :: (hd.to_flush_rev));
                   named_assumptions
                 } in
               {
                 levels = (hd1 :: tl);
                 pending_flushes_rev = (s.pending_flushes_rev);
                 using_facts_from = (s.using_facts_from);
                 prune_sim = (s.prune_sim)
               })
let (give :
  FStar_SMTEncoding_Term.decl Prims.list -> solver_state -> solver_state) =
  fun ds ->
    fun s ->
      let uu___ =
        let uu___1 = FStar_Options.ext_getv "context_pruning" in uu___1 <> "" in
      if uu___ then give_delay_assumptions ds s else give_now ds s
let (reset_with_new_using_facts_from :
  using_facts_from_setting FStar_Pervasives_Native.option ->
    solver_state -> solver_state)
  =
  fun using_facts_from ->
    fun s ->
      let s_new = init () in
      let s_new1 =
        {
          levels = (s_new.levels);
          pending_flushes_rev = (s_new.pending_flushes_rev);
          using_facts_from;
          prune_sim = (s_new.prune_sim)
        } in
      let rec rebuild_one_level all_decls_at_level_rev s_new2 =
        match all_decls_at_level_rev with
        | last::[] -> give last s_new2
        | decls::decls_l ->
            let uu___ = rebuild_one_level decls_l s_new2 in give decls uu___ in
      let rec rebuild levels s_new2 =
        match levels with
        | last::[] ->
            FStar_Compiler_List.fold_right give last.all_decls_at_level_rev
              s_new2
        | level::levels1 ->
            let s_new3 = let uu___ = rebuild levels1 s_new2 in push uu___ in
            FStar_Compiler_List.fold_right give level.all_decls_at_level_rev
              s_new3 in
      rebuild s.levels s_new1
let (reset :
  using_facts_from_setting FStar_Pervasives_Native.option ->
    solver_state -> solver_state)
  =
  fun using_facts_from ->
    fun s ->
      let uu___ = reset_with_new_using_facts_from using_facts_from s in
      {
        levels = (uu___.levels);
        pending_flushes_rev = (uu___.pending_flushes_rev);
        using_facts_from = (uu___.using_facts_from);
        prune_sim = (s.prune_sim)
      }
let (name_of_assumption : FStar_SMTEncoding_Term.decl -> Prims.string) =
  fun d ->
    match d with
    | FStar_SMTEncoding_Term.Assume a ->
        a.FStar_SMTEncoding_Term.assumption_name
    | uu___ -> FStar_Compiler_Effect.failwith "Expected an assumption"
let (prune :
  FStar_SMTEncoding_Term.decl Prims.list ->
    FStar_SMTEncoding_Term.decl -> solver_state -> solver_state)
  =
  fun roots_to_push ->
    fun qry ->
      fun s ->
        let uu___ = peek s in
        match uu___ with
        | (hd, tl) ->
            let to_give =
              FStar_SMTEncoding_Pruning.prune hd.pruning_state (qry ::
                roots_to_push) in
            let uu___1 =
              FStar_Compiler_List.fold_left
                (fun uu___2 ->
                   fun to_give1 ->
                     match uu___2 with
                     | (decl_name_set1, can_give) ->
                         let name = name_of_assumption to_give1 in
                         let uu___3 =
                           let uu___4 =
                             decl_names_contains name decl_name_set1 in
                           Prims.op_Negation uu___4 in
                         if uu___3
                         then
                           let uu___4 = add_name name decl_name_set1 in
                           (uu___4, (to_give1 :: can_give))
                         else (decl_name_set1, can_give))
                ((hd.given_decl_names), []) to_give in
            (match uu___1 with
             | (decl_name_set1, can_give) ->
                 let hd1 =
                   {
                     pruning_state = (hd.pruning_state);
                     given_decl_names = decl_name_set1;
                     all_decls_at_level_rev = (hd.all_decls_at_level_rev);
                     given_some_decls = (hd.given_some_decls);
                     to_flush_rev = (can_give :: (hd.to_flush_rev));
                     named_assumptions = (hd.named_assumptions)
                   } in
                 let s1 =
                   {
                     levels = (hd1 :: tl);
                     pending_flushes_rev = (s.pending_flushes_rev);
                     using_facts_from = (s.using_facts_from);
                     prune_sim = (s.prune_sim)
                   } in
                 let uu___2 = push s1 in give_now roots_to_push uu___2)
let (prune_sim :
  FStar_SMTEncoding_Term.decl Prims.list ->
    FStar_SMTEncoding_Term.decl -> solver_state -> solver_state)
  =
  fun roots_to_push ->
    fun qry ->
      fun s ->
        let uu___ = peek s in
        match uu___ with
        | (hd, tl) ->
            let to_give =
              FStar_SMTEncoding_Pruning.prune hd.pruning_state (qry ::
                roots_to_push) in
            let uu___1 =
              let uu___2 =
                let uu___3 =
                  let uu___4 =
                    FStar_Compiler_List.filter
                      FStar_SMTEncoding_Term.uu___is_Assume roots_to_push in
                  FStar_List_Tot_Base.op_At uu___4 to_give in
                FStar_Compiler_List.map name_of_assumption uu___3 in
              FStar_Pervasives_Native.Some uu___2 in
            {
              levels = (s.levels);
              pending_flushes_rev = (s.pending_flushes_rev);
              using_facts_from = (s.using_facts_from);
              prune_sim = uu___1
            }
let (report_prune_sim :
  Prims.string ->
    FStar_SMTEncoding_UnsatCore.unsat_core -> Prims.string Prims.list -> unit)
  =
  fun qid ->
    fun core ->
      fun prune_sim1 ->
        let missing =
          FStar_Compiler_List.filter
            (fun x ->
               ((((Prims.op_Negation
                     (FStar_Compiler_Util.starts_with x "binder_"))
                    &&
                    (Prims.op_Negation
                       (FStar_Compiler_Util.starts_with x "@query")))
                   &&
                   (Prims.op_Negation
                      (FStar_Compiler_Util.starts_with x "@MaxFuel")))
                  &&
                  (Prims.op_Negation
                     (FStar_Compiler_Util.starts_with x "@MaxIFuel")))
                 &&
                 (Prims.op_Negation
                    (FStar_Compiler_List.contains x prune_sim1))) core in
        if missing <> []
        then
          let uu___ =
            FStar_Class_Show.show
              (FStar_Class_Show.show_list
                 (FStar_Class_Show.printableshow
                    FStar_Class_Printable.printable_string)) missing in
          FStar_Compiler_Util.print2 "Missing from prune (%s): %s\n" qid
            uu___
        else ()
let (would_have_pruned :
  solver_state -> Prims.string Prims.list FStar_Pervasives_Native.option) =
  fun s -> s.prune_sim
let (filter_with_unsat_core :
  Prims.string ->
    FStar_SMTEncoding_UnsatCore.unsat_core ->
      solver_state -> FStar_SMTEncoding_Term.decl Prims.list)
  =
  fun queryid ->
    fun core ->
      fun s ->
        let rec all_decls levels =
          match levels with
          | last::[] -> last.all_decls_at_level_rev
          | level::levels1 ->
              let uu___ =
                let uu___1 = all_decls levels1 in
                [FStar_SMTEncoding_Term.Push
                   (FStar_Compiler_List.length levels1)]
                  :: uu___1 in
              FStar_List_Tot_Base.op_At level.all_decls_at_level_rev uu___ in
        let all_decls1 = all_decls s.levels in
        let all_decls2 =
          FStar_Compiler_List.flatten (FStar_Compiler_List.rev all_decls1) in
        FStar_SMTEncoding_UnsatCore.filter core all_decls2
let (flush :
  solver_state -> (FStar_SMTEncoding_Term.decl Prims.list * solver_state)) =
  fun s ->
    let to_flush =
      let uu___ =
        let uu___1 =
          FStar_Compiler_List.collect (fun level -> level.to_flush_rev)
            s.levels in
        FStar_Compiler_List.rev uu___1 in
      FStar_Compiler_List.flatten uu___ in
    let levels =
      FStar_Compiler_List.map
        (fun level ->
           {
             pruning_state = (level.pruning_state);
             given_decl_names = (level.given_decl_names);
             all_decls_at_level_rev = (level.all_decls_at_level_rev);
             given_some_decls =
               (level.given_some_decls ||
                  (Prims.uu___is_Cons level.to_flush_rev));
             to_flush_rev = [];
             named_assumptions = (level.named_assumptions)
           }) s.levels in
    let s1 =
      {
        levels;
        pending_flushes_rev = [];
        using_facts_from = (s.using_facts_from);
        prune_sim = (s.prune_sim)
      } in
    debug "flush" s s1;
    (let uu___2 =
       let uu___3 = FStar_Options.ext_getv "debug_solver_state" in
       uu___3 <> "" in
     if uu___2
     then
       let uu___3 =
         FStar_Class_Show.show
           (FStar_Class_Show.printableshow
              FStar_Class_Printable.printable_nat)
           (FStar_Compiler_List.length to_flush) in
       FStar_Compiler_Util.print1 "Flushed %s\n" uu___3
     else ());
    (let flushed =
       FStar_List_Tot_Base.op_At
         (FStar_Compiler_List.rev s.pending_flushes_rev) to_flush in
     (flushed, s1))