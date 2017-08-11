
open Prims
open FStar_Pervasives
type verify_mode =
| VerifyAll
| VerifyUserList
| VerifyFigureItOut


let uu___is_VerifyAll : verify_mode  ->  Prims.bool = (fun projectee -> (match (projectee) with
| VerifyAll -> begin
true
end
| uu____5 -> begin
false
end))


let uu___is_VerifyUserList : verify_mode  ->  Prims.bool = (fun projectee -> (match (projectee) with
| VerifyUserList -> begin
true
end
| uu____10 -> begin
false
end))


let uu___is_VerifyFigureItOut : verify_mode  ->  Prims.bool = (fun projectee -> (match (projectee) with
| VerifyFigureItOut -> begin
true
end
| uu____15 -> begin
false
end))


type map =
(Prims.string FStar_Pervasives_Native.option * Prims.string FStar_Pervasives_Native.option) FStar_Util.smap

type color =
| White
| Gray
| Black


let uu___is_White : color  ->  Prims.bool = (fun projectee -> (match (projectee) with
| White -> begin
true
end
| uu____30 -> begin
false
end))


let uu___is_Gray : color  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Gray -> begin
true
end
| uu____35 -> begin
false
end))


let uu___is_Black : color  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Black -> begin
true
end
| uu____40 -> begin
false
end))

type open_kind =
| Open_module
| Open_namespace


let uu___is_Open_module : open_kind  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Open_module -> begin
true
end
| uu____45 -> begin
false
end))


let uu___is_Open_namespace : open_kind  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Open_namespace -> begin
true
end
| uu____50 -> begin
false
end))


let check_and_strip_suffix : Prims.string  ->  Prims.string FStar_Pervasives_Native.option = (fun f -> (

let suffixes = (".fsti")::(".fst")::(".fsi")::(".fs")::[]
in (

let matches = (FStar_List.map (fun ext -> (

let lext = (FStar_String.length ext)
in (

let l = (FStar_String.length f)
in (

let uu____77 = ((l > lext) && (

let uu____89 = (FStar_String.substring f (l - lext) lext)
in (uu____89 = ext)))
in (match (uu____77) with
| true -> begin
(

let uu____106 = (FStar_String.substring f (Prims.parse_int "0") (l - lext))
in FStar_Pervasives_Native.Some (uu____106))
end
| uu____117 -> begin
FStar_Pervasives_Native.None
end))))) suffixes)
in (

let uu____118 = (FStar_List.filter FStar_Util.is_some matches)
in (match (uu____118) with
| (FStar_Pervasives_Native.Some (m))::uu____128 -> begin
FStar_Pervasives_Native.Some (m)
end
| uu____135 -> begin
FStar_Pervasives_Native.None
end)))))


let is_interface : Prims.string  ->  Prims.bool = (fun f -> (

let uu____144 = (FStar_String.get f ((FStar_String.length f) - (Prims.parse_int "1")))
in (uu____144 = 'i')))


let is_implementation : Prims.string  ->  Prims.bool = (fun f -> (

let uu____149 = (is_interface f)
in (not (uu____149))))


let list_of_option : 'Auu____154 . 'Auu____154 FStar_Pervasives_Native.option  ->  'Auu____154 Prims.list = (fun uu___83_162 -> (match (uu___83_162) with
| FStar_Pervasives_Native.Some (x) -> begin
(x)::[]
end
| FStar_Pervasives_Native.None -> begin
[]
end))


let list_of_pair : 'Auu____170 . ('Auu____170 FStar_Pervasives_Native.option * 'Auu____170 FStar_Pervasives_Native.option)  ->  'Auu____170 Prims.list = (fun uu____184 -> (match (uu____184) with
| (intf, impl) -> begin
(FStar_List.append (list_of_option intf) (list_of_option impl))
end))


let lowercase_module_name : Prims.string  ->  Prims.string = (fun f -> (

let uu____207 = (

let uu____210 = (FStar_Util.basename f)
in (check_and_strip_suffix uu____210))
in (match (uu____207) with
| FStar_Pervasives_Native.Some (longname) -> begin
(FStar_String.lowercase longname)
end
| FStar_Pervasives_Native.None -> begin
(

let uu____212 = (

let uu____213 = (FStar_Util.format1 "not a valid FStar file: %s\n" f)
in FStar_Errors.Err (uu____213))
in (FStar_Exn.raise uu____212))
end)))


let build_map : Prims.string Prims.list  ->  map = (fun filenames -> (

let include_directories = (FStar_Options.include_path ())
in (

let include_directories1 = (FStar_List.map FStar_Util.normalize_file_path include_directories)
in (

let include_directories2 = (FStar_List.unique include_directories1)
in (

let cwd = (

let uu____232 = (FStar_Util.getcwd ())
in (FStar_Util.normalize_file_path uu____232))
in (

let map1 = (FStar_Util.smap_create (Prims.parse_int "41"))
in (

let add_entry = (fun key full_path -> (

let uu____259 = (FStar_Util.smap_try_find map1 key)
in (match (uu____259) with
| FStar_Pervasives_Native.Some (intf, impl) -> begin
(

let uu____296 = (is_interface full_path)
in (match (uu____296) with
| true -> begin
(FStar_Util.smap_add map1 key ((FStar_Pervasives_Native.Some (full_path)), (impl)))
end
| uu____309 -> begin
(FStar_Util.smap_add map1 key ((intf), (FStar_Pervasives_Native.Some (full_path))))
end))
end
| FStar_Pervasives_Native.None -> begin
(

let uu____330 = (is_interface full_path)
in (match (uu____330) with
| true -> begin
(FStar_Util.smap_add map1 key ((FStar_Pervasives_Native.Some (full_path)), (FStar_Pervasives_Native.None)))
end
| uu____343 -> begin
(FStar_Util.smap_add map1 key ((FStar_Pervasives_Native.None), (FStar_Pervasives_Native.Some (full_path))))
end))
end)))
in ((FStar_List.iter (fun d -> (match ((FStar_Util.file_exists d)) with
| true -> begin
(

let files = (FStar_Util.readdir d)
in (FStar_List.iter (fun f -> (

let f1 = (FStar_Util.basename f)
in (

let uu____371 = (check_and_strip_suffix f1)
in (match (uu____371) with
| FStar_Pervasives_Native.Some (longname) -> begin
(

let full_path = (match ((d = cwd)) with
| true -> begin
f1
end
| uu____376 -> begin
(FStar_Util.join_paths d f1)
end)
in (

let key = (FStar_String.lowercase longname)
in (add_entry key full_path)))
end
| FStar_Pervasives_Native.None -> begin
()
end)))) files))
end
| uu____378 -> begin
(

let uu____379 = (

let uu____380 = (FStar_Util.format1 "not a valid include directory: %s\n" d)
in FStar_Errors.Err (uu____380))
in (FStar_Exn.raise uu____379))
end)) include_directories2);
(FStar_List.iter (fun f -> (

let uu____385 = (lowercase_module_name f)
in (add_entry uu____385 f))) filenames);
map1;
))))))))


let enter_namespace : map  ->  map  ->  Prims.string  ->  Prims.bool = (fun original_map working_map prefix1 -> (

let found = (FStar_Util.mk_ref false)
in (

let prefix2 = (Prims.strcat prefix1 ".")
in ((

let uu____403 = (

let uu____406 = (FStar_Util.smap_keys original_map)
in (FStar_List.unique uu____406))
in (FStar_List.iter (fun k -> (match ((FStar_Util.starts_with k prefix2)) with
| true -> begin
(

let suffix = (FStar_String.substring k (FStar_String.length prefix2) ((FStar_String.length k) - (FStar_String.length prefix2)))
in (

let filename = (

let uu____432 = (FStar_Util.smap_try_find original_map k)
in (FStar_Util.must uu____432))
in ((FStar_Util.smap_add working_map suffix filename);
(FStar_ST.op_Colon_Equals found true);
)))
end
| uu____492 -> begin
()
end)) uu____403));
(FStar_ST.op_Bang found);
))))


let string_of_lid : FStar_Ident.lident  ->  Prims.bool  ->  Prims.string = (fun l last1 -> (

let suffix = (match (last1) with
| true -> begin
(l.FStar_Ident.ident.FStar_Ident.idText)::[]
end
| uu____530 -> begin
[]
end)
in (

let names = (

let uu____534 = (FStar_List.map (fun x -> x.FStar_Ident.idText) l.FStar_Ident.ns)
in (FStar_List.append uu____534 suffix))
in (FStar_String.concat "." names))))


let lowercase_join_longident : FStar_Ident.lident  ->  Prims.bool  ->  Prims.string = (fun l last1 -> (

let uu____547 = (string_of_lid l last1)
in (FStar_String.lowercase uu____547)))


let namespace_of_lid : FStar_Ident.lident  ->  Prims.string = (fun l -> (

let uu____552 = (FStar_List.map FStar_Ident.text_of_id l.FStar_Ident.ns)
in (FStar_String.concat "_" uu____552)))


let check_module_declaration_against_filename : FStar_Ident.lident  ->  Prims.string  ->  Prims.unit = (fun lid filename -> (

let k' = (lowercase_join_longident lid true)
in (

let uu____564 = (

let uu____565 = (

let uu____566 = (

let uu____567 = (

let uu____570 = (FStar_Util.basename filename)
in (check_and_strip_suffix uu____570))
in (FStar_Util.must uu____567))
in (FStar_String.lowercase uu____566))
in (uu____565 <> k'))
in (match (uu____564) with
| true -> begin
(

let uu____571 = (string_of_lid lid true)
in (FStar_Util.print2_warning "Warning: the module declaration \"module %s\" found in file %s does not match its filename. Dependencies will be incorrect.\n" uu____571 filename))
end
| uu____572 -> begin
()
end))))

exception Exit


let uu___is_Exit : Prims.exn  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Exit -> begin
true
end
| uu____577 -> begin
false
end))


let hard_coded_dependencies : Prims.string  ->  (FStar_Ident.lident * open_kind) Prims.list = (fun filename -> (

let filename1 = (FStar_Util.basename filename)
in (

let corelibs = (

let uu____592 = (FStar_Options.prims_basename ())
in (

let uu____593 = (

let uu____596 = (FStar_Options.pervasives_basename ())
in (

let uu____597 = (

let uu____600 = (FStar_Options.pervasives_native_basename ())
in (uu____600)::[])
in (uu____596)::uu____597))
in (uu____592)::uu____593))
in (match ((FStar_List.mem filename1 corelibs)) with
| true -> begin
[]
end
| uu____611 -> begin
(((FStar_Parser_Const.fstar_ns_lid), (Open_namespace)))::(((FStar_Parser_Const.prims_lid), (Open_module)))::(((FStar_Parser_Const.pervasives_lid), (Open_module)))::[]
end))))


let collect_one : (Prims.string * Prims.bool FStar_ST.ref) Prims.list  ->  verify_mode  ->  Prims.bool  ->  map  ->  Prims.string  ->  Prims.string Prims.list = (fun verify_flags verify_mode is_user_provided_filename original_map filename -> (

let deps = (FStar_Util.mk_ref [])
in (

let add_dep = (fun d -> (

let uu____679 = (

let uu____680 = (

let uu____681 = (FStar_ST.op_Bang deps)
in (FStar_List.existsML (fun d' -> (d' = d)) uu____681))
in (not (uu____680)))
in (match (uu____679) with
| true -> begin
(

let uu____718 = (

let uu____721 = (FStar_ST.op_Bang deps)
in (d)::uu____721)
in (FStar_ST.op_Colon_Equals deps uu____718))
end
| uu____788 -> begin
()
end)))
in (

let working_map = (FStar_Util.smap_copy original_map)
in (

let record_open_module = (fun let_open lid -> (

let key = (lowercase_join_longident lid true)
in (

let uu____816 = (FStar_Util.smap_try_find working_map key)
in (match (uu____816) with
| FStar_Pervasives_Native.Some (pair) -> begin
((FStar_List.iter (fun f -> (

let uu____856 = (lowercase_module_name f)
in (add_dep uu____856))) (list_of_pair pair));
true;
)
end
| FStar_Pervasives_Native.None -> begin
(

let r = (enter_namespace original_map working_map key)
in ((match ((not (r))) with
| true -> begin
(match (let_open) with
| true -> begin
(FStar_Exn.raise (FStar_Errors.Err ("let-open only supported for modules, not namespaces")))
end
| uu____867 -> begin
(

let uu____868 = (string_of_lid lid true)
in (FStar_Util.print2_warning "Warning: in %s: no modules in namespace %s and no file with that name either\n" filename uu____868))
end)
end
| uu____869 -> begin
()
end);
false;
))
end))))
in (

let record_open_namespace = (fun error_msg lid -> (

let key = (lowercase_join_longident lid true)
in (

let r = (enter_namespace original_map working_map key)
in (match ((not (r))) with
| true -> begin
(match (error_msg) with
| FStar_Pervasives_Native.Some (e) -> begin
(FStar_Exn.raise (FStar_Errors.Err (e)))
end
| FStar_Pervasives_Native.None -> begin
(

let uu____884 = (string_of_lid lid true)
in (FStar_Util.print1_warning "Warning: no modules in namespace %s and no file with that name either\n" uu____884))
end)
end
| uu____885 -> begin
()
end))))
in (

let record_open = (fun let_open lid -> (

let uu____893 = (record_open_module let_open lid)
in (match (uu____893) with
| true -> begin
()
end
| uu____894 -> begin
(

let msg = (match (let_open) with
| true -> begin
FStar_Pervasives_Native.Some ("let-open only supported for modules, not namespaces")
end
| uu____900 -> begin
FStar_Pervasives_Native.None
end)
in (record_open_namespace msg lid))
end)))
in (

let record_open_module_or_namespace = (fun uu____908 -> (match (uu____908) with
| (lid, kind) -> begin
(match (kind) with
| Open_namespace -> begin
(record_open_namespace FStar_Pervasives_Native.None lid)
end
| Open_module -> begin
(

let uu____915 = (record_open_module false lid)
in ())
end)
end))
in (

let record_module_alias = (fun ident lid -> (

let key = (FStar_String.lowercase (FStar_Ident.text_of_id ident))
in (

let alias = (lowercase_join_longident lid true)
in (

let uu____925 = (FStar_Util.smap_try_find original_map alias)
in (match (uu____925) with
| FStar_Pervasives_Native.Some (deps_of_aliased_module) -> begin
(FStar_Util.smap_add working_map key deps_of_aliased_module)
end
| FStar_Pervasives_Native.None -> begin
(

let uu____977 = (

let uu____978 = (FStar_Util.format1 "module not found in search path: %s\n" alias)
in FStar_Errors.Err (uu____978))
in (FStar_Exn.raise uu____977))
end)))))
in (

let record_lid = (fun lid -> (

let try_key = (fun key -> (

let uu____987 = (FStar_Util.smap_try_find working_map key)
in (match (uu____987) with
| FStar_Pervasives_Native.Some (pair) -> begin
(FStar_List.iter (fun f -> (

let uu____1026 = (lowercase_module_name f)
in (add_dep uu____1026))) (list_of_pair pair))
end
| FStar_Pervasives_Native.None -> begin
(

let uu____1035 = (((FStar_List.length lid.FStar_Ident.ns) > (Prims.parse_int "0")) && (FStar_Options.debug_any ()))
in (match (uu____1035) with
| true -> begin
(

let uu____1036 = (FStar_Range.string_of_range (FStar_Ident.range_of_lid lid))
in (

let uu____1037 = (string_of_lid lid false)
in (FStar_Util.print2_warning "%s (Warning): unbound module reference %s\n" uu____1036 uu____1037)))
end
| uu____1038 -> begin
()
end))
end)))
in (

let uu____1040 = (lowercase_join_longident lid false)
in (try_key uu____1040))))
in (

let auto_open = (hard_coded_dependencies filename)
in ((FStar_List.iter record_open_module_or_namespace auto_open);
(

let num_of_toplevelmods = (FStar_Util.mk_ref (Prims.parse_int "0"))
in (

let rec collect_file = (fun uu___84_1130 -> (match (uu___84_1130) with
| (modul)::[] -> begin
(collect_module modul)
end
| modules -> begin
((FStar_Util.print1_warning "Warning: file %s does not respect the one module per file convention\n" filename);
(FStar_List.iter collect_module modules);
)
end))
and collect_module = (fun uu___85_1138 -> (match (uu___85_1138) with
| FStar_Parser_AST.Module (lid, decls) -> begin
((check_module_declaration_against_filename lid filename);
(match (((FStar_List.length lid.FStar_Ident.ns) > (Prims.parse_int "0"))) with
| true -> begin
(

let uu____1147 = (

let uu____1148 = (namespace_of_lid lid)
in (enter_namespace original_map working_map uu____1148))
in ())
end
| uu____1149 -> begin
()
end);
(match (verify_mode) with
| VerifyAll -> begin
(

let uu____1151 = (string_of_lid lid true)
in (FStar_Options.add_verify_module uu____1151))
end
| VerifyFigureItOut -> begin
(match (is_user_provided_filename) with
| true -> begin
(

let uu____1152 = (string_of_lid lid true)
in (FStar_Options.add_verify_module uu____1152))
end
| uu____1153 -> begin
()
end)
end
| VerifyUserList -> begin
(FStar_List.iter (fun uu____1220 -> (match (uu____1220) with
| (m, r) -> begin
(

let uu____1401 = (

let uu____1402 = (

let uu____1403 = (string_of_lid lid true)
in (FStar_String.lowercase uu____1403))
in ((FStar_String.lowercase m) = uu____1402))
in (match (uu____1401) with
| true -> begin
(FStar_ST.op_Colon_Equals r true)
end
| uu____1510 -> begin
()
end))
end)) verify_flags)
end);
(collect_decls decls);
)
end
| FStar_Parser_AST.Interface (lid, decls, uu____1513) -> begin
((check_module_declaration_against_filename lid filename);
(match (((FStar_List.length lid.FStar_Ident.ns) > (Prims.parse_int "0"))) with
| true -> begin
(

let uu____1520 = (

let uu____1521 = (namespace_of_lid lid)
in (enter_namespace original_map working_map uu____1521))
in ())
end
| uu____1522 -> begin
()
end);
(match (verify_mode) with
| VerifyAll -> begin
(

let uu____1524 = (string_of_lid lid true)
in (FStar_Options.add_verify_module uu____1524))
end
| VerifyFigureItOut -> begin
(match (is_user_provided_filename) with
| true -> begin
(

let uu____1525 = (string_of_lid lid true)
in (FStar_Options.add_verify_module uu____1525))
end
| uu____1526 -> begin
()
end)
end
| VerifyUserList -> begin
(FStar_List.iter (fun uu____1593 -> (match (uu____1593) with
| (m, r) -> begin
(

let uu____1774 = (

let uu____1775 = (

let uu____1776 = (string_of_lid lid true)
in (FStar_String.lowercase uu____1776))
in ((FStar_String.lowercase m) = uu____1775))
in (match (uu____1774) with
| true -> begin
(FStar_ST.op_Colon_Equals r true)
end
| uu____1883 -> begin
()
end))
end)) verify_flags)
end);
(collect_decls decls);
)
end))
and collect_decls = (fun decls -> (FStar_List.iter (fun x -> ((collect_decl x.FStar_Parser_AST.d);
(FStar_List.iter collect_term x.FStar_Parser_AST.attrs);
)) decls))
and collect_decl = (fun uu___86_1891 -> (match (uu___86_1891) with
| FStar_Parser_AST.Include (lid) -> begin
(record_open false lid)
end
| FStar_Parser_AST.Open (lid) -> begin
(record_open false lid)
end
| FStar_Parser_AST.ModuleAbbrev (ident, lid) -> begin
((

let uu____1897 = (lowercase_join_longident lid true)
in (add_dep uu____1897));
(record_module_alias ident lid);
)
end
| FStar_Parser_AST.TopLevelLet (uu____1898, patterms) -> begin
(FStar_List.iter (fun uu____1920 -> (match (uu____1920) with
| (pat, t) -> begin
((collect_pattern pat);
(collect_term t);
)
end)) patterms)
end
| FStar_Parser_AST.Main (t) -> begin
(collect_term t)
end
| FStar_Parser_AST.Assume (uu____1929, t) -> begin
(collect_term t)
end
| FStar_Parser_AST.SubEffect ({FStar_Parser_AST.msource = uu____1931; FStar_Parser_AST.mdest = uu____1932; FStar_Parser_AST.lift_op = FStar_Parser_AST.NonReifiableLift (t)}) -> begin
(collect_term t)
end
| FStar_Parser_AST.SubEffect ({FStar_Parser_AST.msource = uu____1934; FStar_Parser_AST.mdest = uu____1935; FStar_Parser_AST.lift_op = FStar_Parser_AST.LiftForFree (t)}) -> begin
(collect_term t)
end
| FStar_Parser_AST.Val (uu____1937, t) -> begin
(collect_term t)
end
| FStar_Parser_AST.SubEffect ({FStar_Parser_AST.msource = uu____1939; FStar_Parser_AST.mdest = uu____1940; FStar_Parser_AST.lift_op = FStar_Parser_AST.ReifiableLift (t0, t1)}) -> begin
((collect_term t0);
(collect_term t1);
)
end
| FStar_Parser_AST.Tycon (uu____1944, ts) -> begin
(

let ts1 = (FStar_List.map (fun uu____1974 -> (match (uu____1974) with
| (x, docnik) -> begin
x
end)) ts)
in (FStar_List.iter collect_tycon ts1))
end
| FStar_Parser_AST.Exception (uu____1987, t) -> begin
(FStar_Util.iter_opt t collect_term)
end
| FStar_Parser_AST.NewEffect (ed) -> begin
(collect_effect_decl ed)
end
| FStar_Parser_AST.Fsdoc (uu____1994) -> begin
()
end
| FStar_Parser_AST.Pragma (uu____1995) -> begin
()
end
| FStar_Parser_AST.TopLevelModule (lid) -> begin
((FStar_Util.incr num_of_toplevelmods);
(

let uu____2019 = (

let uu____2020 = (FStar_ST.op_Bang num_of_toplevelmods)
in (uu____2020 > (Prims.parse_int "1")))
in (match (uu____2019) with
| true -> begin
(

let uu____2045 = (

let uu____2046 = (

let uu____2047 = (string_of_lid lid true)
in (FStar_Util.format1 "Automatic dependency analysis demands one module per file (module %s not supported)" uu____2047))
in FStar_Errors.Err (uu____2046))
in (FStar_Exn.raise uu____2045))
end
| uu____2048 -> begin
()
end));
)
end))
and collect_tycon = (fun uu___87_2049 -> (match (uu___87_2049) with
| FStar_Parser_AST.TyconAbstract (uu____2050, binders, k) -> begin
((collect_binders binders);
(FStar_Util.iter_opt k collect_term);
)
end
| FStar_Parser_AST.TyconAbbrev (uu____2062, binders, k, t) -> begin
((collect_binders binders);
(FStar_Util.iter_opt k collect_term);
(collect_term t);
)
end
| FStar_Parser_AST.TyconRecord (uu____2076, binders, k, identterms) -> begin
((collect_binders binders);
(FStar_Util.iter_opt k collect_term);
(FStar_List.iter (fun uu____2122 -> (match (uu____2122) with
| (uu____2131, t, uu____2133) -> begin
(collect_term t)
end)) identterms);
)
end
| FStar_Parser_AST.TyconVariant (uu____2138, binders, k, identterms) -> begin
((collect_binders binders);
(FStar_Util.iter_opt k collect_term);
(FStar_List.iter (fun uu____2197 -> (match (uu____2197) with
| (uu____2210, t, uu____2212, uu____2213) -> begin
(FStar_Util.iter_opt t collect_term)
end)) identterms);
)
end))
and collect_effect_decl = (fun uu___88_2222 -> (match (uu___88_2222) with
| FStar_Parser_AST.DefineEffect (uu____2223, binders, t, decls) -> begin
((collect_binders binders);
(collect_term t);
(collect_decls decls);
)
end
| FStar_Parser_AST.RedefineEffect (uu____2237, binders, t) -> begin
((collect_binders binders);
(collect_term t);
)
end))
and collect_binders = (fun binders -> (FStar_List.iter collect_binder binders))
and collect_binder = (fun uu___89_2248 -> (match (uu___89_2248) with
| {FStar_Parser_AST.b = FStar_Parser_AST.Annotated (uu____2249, t); FStar_Parser_AST.brange = uu____2251; FStar_Parser_AST.blevel = uu____2252; FStar_Parser_AST.aqual = uu____2253} -> begin
(collect_term t)
end
| {FStar_Parser_AST.b = FStar_Parser_AST.TAnnotated (uu____2254, t); FStar_Parser_AST.brange = uu____2256; FStar_Parser_AST.blevel = uu____2257; FStar_Parser_AST.aqual = uu____2258} -> begin
(collect_term t)
end
| {FStar_Parser_AST.b = FStar_Parser_AST.NoName (t); FStar_Parser_AST.brange = uu____2260; FStar_Parser_AST.blevel = uu____2261; FStar_Parser_AST.aqual = uu____2262} -> begin
(collect_term t)
end
| uu____2263 -> begin
()
end))
and collect_term = (fun t -> (collect_term' t.FStar_Parser_AST.tm))
and collect_constant = (fun uu___90_2265 -> (match (uu___90_2265) with
| FStar_Const.Const_int (uu____2266, FStar_Pervasives_Native.Some (signedness, width)) -> begin
(

let u = (match (signedness) with
| FStar_Const.Unsigned -> begin
"u"
end
| FStar_Const.Signed -> begin
""
end)
in (

let w = (match (width) with
| FStar_Const.Int8 -> begin
"8"
end
| FStar_Const.Int16 -> begin
"16"
end
| FStar_Const.Int32 -> begin
"32"
end
| FStar_Const.Int64 -> begin
"64"
end)
in (

let uu____2281 = (FStar_Util.format2 "fstar.%sint%s" u w)
in (add_dep uu____2281))))
end
| uu____2282 -> begin
()
end))
and collect_term' = (fun uu___91_2283 -> (match (uu___91_2283) with
| FStar_Parser_AST.Wild -> begin
()
end
| FStar_Parser_AST.Const (c) -> begin
(collect_constant c)
end
| FStar_Parser_AST.Op (s, ts) -> begin
((match (((FStar_Ident.text_of_id s) = "@")) with
| true -> begin
(

let uu____2292 = (

let uu____2293 = (FStar_Ident.lid_of_path (FStar_Ident.path_of_text "FStar.List.Tot.Base.append") FStar_Range.dummyRange)
in FStar_Parser_AST.Name (uu____2293))
in (collect_term' uu____2292))
end
| uu____2294 -> begin
()
end);
(FStar_List.iter collect_term ts);
)
end
| FStar_Parser_AST.Tvar (uu____2295) -> begin
()
end
| FStar_Parser_AST.Uvar (uu____2296) -> begin
()
end
| FStar_Parser_AST.Var (lid) -> begin
(record_lid lid)
end
| FStar_Parser_AST.Projector (lid, uu____2299) -> begin
(record_lid lid)
end
| FStar_Parser_AST.Discrim (lid) -> begin
(record_lid lid)
end
| FStar_Parser_AST.Name (lid) -> begin
(record_lid lid)
end
| FStar_Parser_AST.Construct (lid, termimps) -> begin
((match (((FStar_List.length termimps) = (Prims.parse_int "1"))) with
| true -> begin
(record_lid lid)
end
| uu____2321 -> begin
()
end);
(FStar_List.iter (fun uu____2329 -> (match (uu____2329) with
| (t, uu____2335) -> begin
(collect_term t)
end)) termimps);
)
end
| FStar_Parser_AST.Abs (pats, t) -> begin
((collect_patterns pats);
(collect_term t);
)
end
| FStar_Parser_AST.App (t1, t2, uu____2345) -> begin
((collect_term t1);
(collect_term t2);
)
end
| FStar_Parser_AST.Let (uu____2347, patterms, t) -> begin
((FStar_List.iter (fun uu____2371 -> (match (uu____2371) with
| (pat, t1) -> begin
((collect_pattern pat);
(collect_term t1);
)
end)) patterms);
(collect_term t);
)
end
| FStar_Parser_AST.LetOpen (lid, t) -> begin
((record_open true lid);
(collect_term t);
)
end
| FStar_Parser_AST.Bind (uu____2382, t1, t2) -> begin
((collect_term t1);
(collect_term t2);
)
end
| FStar_Parser_AST.Seq (t1, t2) -> begin
((collect_term t1);
(collect_term t2);
)
end
| FStar_Parser_AST.If (t1, t2, t3) -> begin
((collect_term t1);
(collect_term t2);
(collect_term t3);
)
end
| FStar_Parser_AST.Match (t, bs) -> begin
((collect_term t);
(collect_branches bs);
)
end
| FStar_Parser_AST.TryWith (t, bs) -> begin
((collect_term t);
(collect_branches bs);
)
end
| FStar_Parser_AST.Ascribed (t1, t2, FStar_Pervasives_Native.None) -> begin
((collect_term t1);
(collect_term t2);
)
end
| FStar_Parser_AST.Ascribed (t1, t2, FStar_Pervasives_Native.Some (tac)) -> begin
((collect_term t1);
(collect_term t2);
(collect_term tac);
)
end
| FStar_Parser_AST.Record (t, idterms) -> begin
((FStar_Util.iter_opt t collect_term);
(FStar_List.iter (fun uu____2478 -> (match (uu____2478) with
| (uu____2483, t1) -> begin
(collect_term t1)
end)) idterms);
)
end
| FStar_Parser_AST.Project (t, uu____2486) -> begin
(collect_term t)
end
| FStar_Parser_AST.Product (binders, t) -> begin
((collect_binders binders);
(collect_term t);
)
end
| FStar_Parser_AST.Sum (binders, t) -> begin
((collect_binders binders);
(collect_term t);
)
end
| FStar_Parser_AST.QForall (binders, ts, t) -> begin
((collect_binders binders);
(FStar_List.iter (FStar_List.iter collect_term) ts);
(collect_term t);
)
end
| FStar_Parser_AST.QExists (binders, ts, t) -> begin
((collect_binders binders);
(FStar_List.iter (FStar_List.iter collect_term) ts);
(collect_term t);
)
end
| FStar_Parser_AST.Refine (binder, t) -> begin
((collect_binder binder);
(collect_term t);
)
end
| FStar_Parser_AST.NamedTyp (uu____2542, t) -> begin
(collect_term t)
end
| FStar_Parser_AST.Paren (t) -> begin
(collect_term t)
end
| FStar_Parser_AST.Assign (uu____2545, t) -> begin
(collect_term t)
end
| FStar_Parser_AST.Requires (t, uu____2548) -> begin
(collect_term t)
end
| FStar_Parser_AST.Ensures (t, uu____2554) -> begin
(collect_term t)
end
| FStar_Parser_AST.Labeled (t, uu____2560, uu____2561) -> begin
(collect_term t)
end
| FStar_Parser_AST.Attributes (cattributes) -> begin
(FStar_List.iter collect_term cattributes)
end))
and collect_patterns = (fun ps -> (FStar_List.iter collect_pattern ps))
and collect_pattern = (fun p -> (collect_pattern' p.FStar_Parser_AST.pat))
and collect_pattern' = (fun uu___92_2569 -> (match (uu___92_2569) with
| FStar_Parser_AST.PatWild -> begin
()
end
| FStar_Parser_AST.PatOp (uu____2570) -> begin
()
end
| FStar_Parser_AST.PatConst (uu____2571) -> begin
()
end
| FStar_Parser_AST.PatApp (p, ps) -> begin
((collect_pattern p);
(collect_patterns ps);
)
end
| FStar_Parser_AST.PatVar (uu____2579) -> begin
()
end
| FStar_Parser_AST.PatName (uu____2586) -> begin
()
end
| FStar_Parser_AST.PatTvar (uu____2587) -> begin
()
end
| FStar_Parser_AST.PatList (ps) -> begin
(collect_patterns ps)
end
| FStar_Parser_AST.PatOr (ps) -> begin
(collect_patterns ps)
end
| FStar_Parser_AST.PatTuple (ps, uu____2601) -> begin
(collect_patterns ps)
end
| FStar_Parser_AST.PatRecord (lidpats) -> begin
(FStar_List.iter (fun uu____2620 -> (match (uu____2620) with
| (uu____2625, p) -> begin
(collect_pattern p)
end)) lidpats)
end
| FStar_Parser_AST.PatAscribed (p, t) -> begin
((collect_pattern p);
(collect_term t);
)
end))
and collect_branches = (fun bs -> (FStar_List.iter collect_branch bs))
and collect_branch = (fun uu____2649 -> (match (uu____2649) with
| (pat, t1, t2) -> begin
((collect_pattern pat);
(FStar_Util.iter_opt t1 collect_term);
(collect_term t2);
)
end))
in (

let uu____2667 = (FStar_Parser_Driver.parse_file filename)
in (match (uu____2667) with
| (ast, uu____2681) -> begin
((collect_file ast);
(FStar_ST.op_Bang deps);
)
end))));
))))))))))))


let print_graph : 'Auu____2731 . (Prims.string Prims.list * 'Auu____2731) FStar_Util.smap  ->  Prims.unit = (fun graph -> ((FStar_Util.print_endline "A DOT-format graph has been dumped in the current directory as dep.graph");
(FStar_Util.print_endline "With GraphViz installed, try: fdp -Tpng -odep.png dep.graph");
(FStar_Util.print_endline "Hint: cat dep.graph | grep -v _ | grep -v prims");
(

let uu____2755 = (

let uu____2756 = (

let uu____2757 = (

let uu____2758 = (

let uu____2761 = (

let uu____2764 = (FStar_Util.smap_keys graph)
in (FStar_List.unique uu____2764))
in (FStar_List.collect (fun k -> (

let deps = (

let uu____2780 = (

let uu____2787 = (FStar_Util.smap_try_find graph k)
in (FStar_Util.must uu____2787))
in (FStar_Pervasives_Native.fst uu____2780))
in (

let r = (fun s -> (FStar_Util.replace_char s '.' '_'))
in (FStar_List.map (fun dep1 -> (FStar_Util.format2 "  %s -> %s" (r k) (r dep1))) deps)))) uu____2761))
in (FStar_String.concat "\n" uu____2758))
in (Prims.strcat uu____2757 "\n}\n"))
in (Prims.strcat "digraph {\n" uu____2756))
in (FStar_Util.write_file "dep.graph" uu____2755));
))


let collect : verify_mode  ->  Prims.string Prims.list  ->  ((Prims.string * Prims.string Prims.list) Prims.list * Prims.string Prims.list * (Prims.string Prims.list * color) FStar_Util.smap) = (fun verify_mode filenames -> (

let graph = (FStar_Util.smap_create (Prims.parse_int "41"))
in (

let verify_flags = (

let uu____2876 = (FStar_Options.verify_module ())
in (FStar_List.map (fun f -> (

let uu____2888 = (FStar_Util.mk_ref false)
in ((f), (uu____2888)))) uu____2876))
in (

let partial_discovery = (

let uu____2908 = ((FStar_Options.verify_all ()) || (FStar_Options.extract_all ()))
in (not (uu____2908)))
in (

let m = (build_map filenames)
in (

let file_names_of_key = (fun k -> (

let uu____2914 = (

let uu____2923 = (FStar_Util.smap_try_find m k)
in (FStar_Util.must uu____2923))
in (match (uu____2914) with
| (intf, impl) -> begin
(match (((intf), (impl))) with
| (FStar_Pervasives_Native.None, FStar_Pervasives_Native.None) -> begin
(failwith "Impossible")
end
| (FStar_Pervasives_Native.None, FStar_Pervasives_Native.Some (i)) -> begin
i
end
| (FStar_Pervasives_Native.Some (i), FStar_Pervasives_Native.None) -> begin
i
end
| (FStar_Pervasives_Native.Some (i), uu____2979) when partial_discovery -> begin
i
end
| (FStar_Pervasives_Native.Some (i), FStar_Pervasives_Native.Some (j)) -> begin
(Prims.strcat i (Prims.strcat " && " j))
end)
end)))
in (

let collect_one1 = (collect_one verify_flags verify_mode)
in (

let rec discover_one = (fun is_user_provided_filename interface_only key -> (

let uu____3011 = (

let uu____3012 = (FStar_Util.smap_try_find graph key)
in (uu____3012 = FStar_Pervasives_Native.None))
in (match (uu____3011) with
| true -> begin
(

let uu____3041 = (

let uu____3050 = (FStar_Util.smap_try_find m key)
in (FStar_Util.must uu____3050))
in (match (uu____3041) with
| (intf, impl) -> begin
(

let intf_deps = (match (intf) with
| FStar_Pervasives_Native.Some (intf1) -> begin
(collect_one1 is_user_provided_filename m intf1)
end
| FStar_Pervasives_Native.None -> begin
[]
end)
in (

let impl_deps = (match (((impl), (intf))) with
| (FStar_Pervasives_Native.Some (impl1), FStar_Pervasives_Native.Some (uu____3103)) when interface_only -> begin
[]
end
| (FStar_Pervasives_Native.Some (impl1), uu____3109) -> begin
(collect_one1 is_user_provided_filename m impl1)
end
| (FStar_Pervasives_Native.None, uu____3116) -> begin
[]
end)
in (

let deps = (FStar_List.unique (FStar_List.append impl_deps intf_deps))
in ((FStar_Util.smap_add graph key ((deps), (White)));
(FStar_List.iter (discover_one false partial_discovery) deps);
))))
end))
end
| uu____3135 -> begin
()
end)))
in (

let discover_command_line_argument = (fun f -> (

let m1 = (lowercase_module_name f)
in (

let interface_only = ((is_interface f) && (

let uu____3143 = (FStar_List.existsML (fun f1 -> ((

let uu____3148 = (lowercase_module_name f1)
in (uu____3148 = m1)) && (is_implementation f1))) filenames)
in (not (uu____3143))))
in (discover_one true interface_only m1))))
in ((FStar_List.iter discover_command_line_argument filenames);
(

let immediate_graph = (FStar_Util.smap_copy graph)
in (

let topologically_sorted = (FStar_Util.mk_ref [])
in (

let rec discover = (fun cycle key -> (

let uu____3185 = (

let uu____3192 = (FStar_Util.smap_try_find graph key)
in (FStar_Util.must uu____3192))
in (match (uu____3185) with
| (direct_deps, color) -> begin
(match (color) with
| Gray -> begin
((FStar_Util.print1 "Warning: recursive dependency on module %s\n" key);
(

let cycle1 = (FStar_All.pipe_right cycle (FStar_List.map file_names_of_key))
in ((FStar_Util.print1 "The cycle contains a subset of the modules in:\n%s \n" (FStar_String.concat "\n`used by` " cycle1));
(print_graph immediate_graph);
(FStar_Util.print_string "\n");
(FStar_All.exit (Prims.parse_int "1"));
));
)
end
| Black -> begin
direct_deps
end
| White -> begin
((FStar_Util.smap_add graph key ((direct_deps), (Gray)));
(

let all_deps = (

let uu____3248 = (

let uu____3251 = (FStar_List.map (fun dep1 -> (

let uu____3261 = (discover ((key)::cycle) dep1)
in (dep1)::uu____3261)) direct_deps)
in (FStar_List.flatten uu____3251))
in (FStar_List.unique uu____3248))
in ((FStar_Util.smap_add graph key ((all_deps), (Black)));
(

let uu____3274 = (

let uu____3277 = (FStar_ST.op_Bang topologically_sorted)
in (key)::uu____3277)
in (FStar_ST.op_Colon_Equals topologically_sorted uu____3274));
all_deps;
));
)
end)
end)))
in (

let discover1 = (discover [])
in (

let must_find = (fun k -> (

let uu____3355 = (

let uu____3364 = (FStar_Util.smap_try_find m k)
in (FStar_Util.must uu____3364))
in (match (uu____3355) with
| (FStar_Pervasives_Native.Some (intf), FStar_Pervasives_Native.Some (impl)) when ((not (partial_discovery)) && (

let uu____3400 = (FStar_List.existsML (fun f -> (

let uu____3404 = (lowercase_module_name f)
in (uu____3404 = k))) filenames)
in (not (uu____3400)))) -> begin
(intf)::(impl)::[]
end
| (FStar_Pervasives_Native.Some (intf), FStar_Pervasives_Native.Some (impl)) when (FStar_List.existsML (fun f -> ((is_implementation f) && (

let uu____3414 = (lowercase_module_name f)
in (uu____3414 = k)))) filenames) -> begin
(intf)::(impl)::[]
end
| (FStar_Pervasives_Native.Some (intf), uu____3416) -> begin
(intf)::[]
end
| (FStar_Pervasives_Native.None, FStar_Pervasives_Native.Some (impl)) -> begin
(impl)::[]
end
| (FStar_Pervasives_Native.None, FStar_Pervasives_Native.None) -> begin
[]
end)))
in (

let must_find_r = (fun f -> (

let uu____3438 = (must_find f)
in (FStar_List.rev uu____3438)))
in (

let by_target = (

let uu____3450 = (

let uu____3453 = (FStar_Util.smap_keys graph)
in (FStar_List.sortWith (fun x y -> (FStar_String.compare x y)) uu____3453))
in (FStar_List.collect (fun k -> (

let as_list = (must_find k)
in (

let is_interleaved = ((FStar_List.length as_list) = (Prims.parse_int "2"))
in (FStar_List.map (fun f -> (

let should_append_fsti = ((is_implementation f) && is_interleaved)
in (

let k1 = (lowercase_module_name f)
in (

let suffix = (

let uu____3498 = (

let uu____3507 = (FStar_Util.smap_try_find m k1)
in (FStar_Util.must uu____3507))
in (match (uu____3498) with
| (FStar_Pervasives_Native.Some (intf), uu____3537) when should_append_fsti -> begin
(intf)::[]
end
| uu____3544 -> begin
[]
end))
in (

let deps = (

let uu____3556 = (discover1 k1)
in (FStar_List.rev uu____3556))
in (

let deps_as_filenames = (

let uu____3562 = (FStar_List.collect must_find deps)
in (FStar_List.append uu____3562 suffix))
in ((f), (deps_as_filenames)))))))) as_list)))) uu____3450))
in (

let topologically_sorted1 = (

let uu____3570 = (FStar_ST.op_Bang topologically_sorted)
in (FStar_List.collect must_find_r uu____3570))
in ((FStar_List.iter (fun uu____3674 -> (match (uu____3674) with
| (m1, r) -> begin
(

let uu____3855 = ((

let uu____3858 = (FStar_ST.op_Bang r)
in (not (uu____3858))) && (

let uu____3966 = (FStar_Options.interactive ())
in (not (uu____3966))))
in (match (uu____3855) with
| true -> begin
(

let maybe_fst = (

let k = (FStar_String.length m1)
in (

let uu____3969 = ((k > (Prims.parse_int "4")) && (

let uu____3977 = (FStar_String.substring m1 (k - (Prims.parse_int "4")) (Prims.parse_int "4"))
in (uu____3977 = ".fst")))
in (match (uu____3969) with
| true -> begin
(

let uu____3984 = (FStar_String.substring m1 (Prims.parse_int "0") (k - (Prims.parse_int "4")))
in (FStar_Util.format1 " Did you mean %s ?" uu____3984))
end
| uu____3991 -> begin
""
end)))
in (

let uu____3992 = (

let uu____3993 = (FStar_Util.format3 "You passed --verify_module %s but I found no file that contains [module %s] in the dependency graph.%s\n" m1 m1 maybe_fst)
in FStar_Errors.Err (uu____3993))
in (FStar_Exn.raise uu____3992)))
end
| uu____3994 -> begin
()
end))
end)) verify_flags);
((by_target), (topologically_sorted1), (immediate_graph));
)))))))));
))))))))))


let print_make : (Prims.string * Prims.string Prims.list) Prims.list  ->  Prims.unit = (fun deps -> (FStar_List.iter (fun uu____4043 -> (match (uu____4043) with
| (f, deps1) -> begin
(

let deps2 = (FStar_List.map (fun s -> (FStar_Util.replace_chars s ' ' "\\ ")) deps1)
in (FStar_Util.print2 "%s: %s\n" f (FStar_String.concat " " deps2)))
end)) deps))


let print : 'a 'b . ((Prims.string * Prims.string Prims.list) Prims.list * 'a * (Prims.string Prims.list * 'b) FStar_Util.smap)  ->  Prims.unit = (fun uu____4094 -> (match (uu____4094) with
| (make_deps, uu____4118, graph) -> begin
(

let uu____4152 = (FStar_Options.dep ())
in (match (uu____4152) with
| FStar_Pervasives_Native.Some ("make") -> begin
(print_make make_deps)
end
| FStar_Pervasives_Native.Some ("graph") -> begin
(print_graph graph)
end
| FStar_Pervasives_Native.Some (uu____4155) -> begin
(FStar_Exn.raise (FStar_Errors.Err ("unknown tool for --dep\n")))
end
| FStar_Pervasives_Native.None -> begin
()
end))
end))




