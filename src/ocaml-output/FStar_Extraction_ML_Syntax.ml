
open Prims
open FStar_Pervasives

type mlsymbol =
Prims.string


type mlident =
(mlsymbol * Prims.int)


type mlpath =
(mlsymbol Prims.list * mlsymbol)


let ocamlkeywords : Prims.string Prims.list = ("and")::("as")::("assert")::("asr")::("begin")::("class")::("constraint")::("do")::("done")::("downto")::("else")::("end")::("exception")::("external")::("false")::("for")::("fun")::("function")::("functor")::("if")::("in")::("include")::("inherit")::("initializer")::("land")::("lazy")::("let")::("lor")::("lsl")::("lsr")::("lxor")::("match")::("method")::("mod")::("module")::("mutable")::("new")::("object")::("of")::("open")::("or")::("private")::("rec")::("sig")::("struct")::("then")::("to")::("true")::("try")::("type")::("val")::("virtual")::("when")::("while")::("with")::("nonrec")::[]


let is_reserved : Prims.string  ->  Prims.bool = (fun k -> (FStar_List.existsb (fun k' -> (k' = k)) ocamlkeywords))


let idsym : mlident  ->  mlsymbol = (fun uu____22 -> (match (uu____22) with
| (s, uu____24) -> begin
s
end))


let string_of_mlpath : mlpath  ->  mlsymbol = (fun uu____28 -> (match (uu____28) with
| (p, s) -> begin
(FStar_String.concat "." (FStar_List.append p ((s)::[])))
end))

type gensym_t =
{gensym : Prims.unit  ->  mlident; reset : Prims.unit  ->  Prims.unit}


let __proj__Mkgensym_t__item__gensym : gensym_t  ->  Prims.unit  ->  mlident = (fun projectee -> (match (projectee) with
| {gensym = __fname__gensym; reset = __fname__reset} -> begin
__fname__gensym
end))


let __proj__Mkgensym_t__item__reset : gensym_t  ->  Prims.unit  ->  Prims.unit = (fun projectee -> (match (projectee) with
| {gensym = __fname__gensym; reset = __fname__reset} -> begin
__fname__reset
end))


let gs : gensym_t = (

let ctr = (FStar_Util.mk_ref (Prims.parse_int "0"))
in (

let n_resets = (FStar_Util.mk_ref (Prims.parse_int "0"))
in {gensym = (fun uu____93 -> ((FStar_Util.incr ctr);
(

let uu____116 = (

let uu____117 = (

let uu____118 = (

let uu____119 = (FStar_ST.op_Bang n_resets)
in (FStar_Util.string_of_int uu____119))
in (

let uu____144 = (

let uu____145 = (

let uu____146 = (FStar_ST.op_Bang ctr)
in (FStar_Util.string_of_int uu____146))
in (Prims.strcat "_" uu____145))
in (Prims.strcat uu____118 uu____144)))
in (Prims.strcat "_" uu____117))
in ((uu____116), ((Prims.parse_int "0"))));
)); reset = (fun uu____173 -> ((FStar_ST.op_Colon_Equals ctr (Prims.parse_int "0"));
(FStar_Util.incr n_resets);
))}))


let gensym : Prims.unit  ->  mlident = (fun uu____223 -> (gs.gensym ()))


let reset_gensym : Prims.unit  ->  Prims.unit = (fun uu____227 -> (gs.reset ()))


let rec gensyms : Prims.int  ->  mlident Prims.list = (fun x -> (match (x) with
| _0_41 when (_0_41 = (Prims.parse_int "0")) -> begin
[]
end
| n1 -> begin
(

let uu____237 = (gensym ())
in (

let uu____238 = (gensyms (n1 - (Prims.parse_int "1")))
in (uu____237)::uu____238))
end))


let mlpath_of_lident : FStar_Ident.lident  ->  mlpath = (fun x -> (match ((FStar_Ident.lid_equals x FStar_Parser_Const.failwith_lid)) with
| true -> begin
(([]), (x.FStar_Ident.ident.FStar_Ident.idText))
end
| uu____247 -> begin
(

let uu____248 = (FStar_List.map (fun x1 -> x1.FStar_Ident.idText) x.FStar_Ident.ns)
in ((uu____248), (x.FStar_Ident.ident.FStar_Ident.idText)))
end))


type mlidents =
mlident Prims.list


type mlsymbols =
mlsymbol Prims.list

type e_tag =
| E_PURE
| E_GHOST
| E_IMPURE


let uu___is_E_PURE : e_tag  ->  Prims.bool = (fun projectee -> (match (projectee) with
| E_PURE -> begin
true
end
| uu____263 -> begin
false
end))


let uu___is_E_GHOST : e_tag  ->  Prims.bool = (fun projectee -> (match (projectee) with
| E_GHOST -> begin
true
end
| uu____268 -> begin
false
end))


let uu___is_E_IMPURE : e_tag  ->  Prims.bool = (fun projectee -> (match (projectee) with
| E_IMPURE -> begin
true
end
| uu____273 -> begin
false
end))


type mlloc =
(Prims.int * Prims.string)


let dummy_loc : (Prims.int * Prims.string) = (((Prims.parse_int "0")), (""))

type mlty =
| MLTY_Var of mlident
| MLTY_Fun of (mlty * e_tag * mlty)
| MLTY_Named of (mlty Prims.list * mlpath)
| MLTY_Tuple of mlty Prims.list
| MLTY_Top


let uu___is_MLTY_Var : mlty  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLTY_Var (_0) -> begin
true
end
| uu____317 -> begin
false
end))


let __proj__MLTY_Var__item___0 : mlty  ->  mlident = (fun projectee -> (match (projectee) with
| MLTY_Var (_0) -> begin
_0
end))


let uu___is_MLTY_Fun : mlty  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLTY_Fun (_0) -> begin
true
end
| uu____337 -> begin
false
end))


let __proj__MLTY_Fun__item___0 : mlty  ->  (mlty * e_tag * mlty) = (fun projectee -> (match (projectee) with
| MLTY_Fun (_0) -> begin
_0
end))


let uu___is_MLTY_Named : mlty  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLTY_Named (_0) -> begin
true
end
| uu____375 -> begin
false
end))


let __proj__MLTY_Named__item___0 : mlty  ->  (mlty Prims.list * mlpath) = (fun projectee -> (match (projectee) with
| MLTY_Named (_0) -> begin
_0
end))


let uu___is_MLTY_Tuple : mlty  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLTY_Tuple (_0) -> begin
true
end
| uu____409 -> begin
false
end))


let __proj__MLTY_Tuple__item___0 : mlty  ->  mlty Prims.list = (fun projectee -> (match (projectee) with
| MLTY_Tuple (_0) -> begin
_0
end))


let uu___is_MLTY_Top : mlty  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLTY_Top -> begin
true
end
| uu____428 -> begin
false
end))


type mltyscheme =
(mlidents * mlty)

type mlconstant =
| MLC_Unit
| MLC_Bool of Prims.bool
| MLC_Int of (Prims.string * (FStar_Const.signedness * FStar_Const.width) FStar_Pervasives_Native.option)
| MLC_Float of FStar_BaseTypes.float
| MLC_Char of FStar_BaseTypes.char
| MLC_String of Prims.string
| MLC_Bytes of FStar_BaseTypes.byte Prims.array


let uu___is_MLC_Unit : mlconstant  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLC_Unit -> begin
true
end
| uu____473 -> begin
false
end))


let uu___is_MLC_Bool : mlconstant  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLC_Bool (_0) -> begin
true
end
| uu____479 -> begin
false
end))


let __proj__MLC_Bool__item___0 : mlconstant  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLC_Bool (_0) -> begin
_0
end))


let uu___is_MLC_Int : mlconstant  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLC_Int (_0) -> begin
true
end
| uu____503 -> begin
false
end))


let __proj__MLC_Int__item___0 : mlconstant  ->  (Prims.string * (FStar_Const.signedness * FStar_Const.width) FStar_Pervasives_Native.option) = (fun projectee -> (match (projectee) with
| MLC_Int (_0) -> begin
_0
end))


let uu___is_MLC_Float : mlconstant  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLC_Float (_0) -> begin
true
end
| uu____547 -> begin
false
end))


let __proj__MLC_Float__item___0 : mlconstant  ->  FStar_BaseTypes.float = (fun projectee -> (match (projectee) with
| MLC_Float (_0) -> begin
_0
end))


let uu___is_MLC_Char : mlconstant  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLC_Char (_0) -> begin
true
end
| uu____561 -> begin
false
end))


let __proj__MLC_Char__item___0 : mlconstant  ->  FStar_BaseTypes.char = (fun projectee -> (match (projectee) with
| MLC_Char (_0) -> begin
_0
end))


let uu___is_MLC_String : mlconstant  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLC_String (_0) -> begin
true
end
| uu____575 -> begin
false
end))


let __proj__MLC_String__item___0 : mlconstant  ->  Prims.string = (fun projectee -> (match (projectee) with
| MLC_String (_0) -> begin
_0
end))


let uu___is_MLC_Bytes : mlconstant  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLC_Bytes (_0) -> begin
true
end
| uu____591 -> begin
false
end))


let __proj__MLC_Bytes__item___0 : mlconstant  ->  FStar_BaseTypes.byte Prims.array = (fun projectee -> (match (projectee) with
| MLC_Bytes (_0) -> begin
_0
end))

type mlpattern =
| MLP_Wild
| MLP_Const of mlconstant
| MLP_Var of mlident
| MLP_CTor of (mlpath * mlpattern Prims.list)
| MLP_Branch of mlpattern Prims.list
| MLP_Record of (mlsymbol Prims.list * (mlsymbol * mlpattern) Prims.list)
| MLP_Tuple of mlpattern Prims.list


let uu___is_MLP_Wild : mlpattern  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLP_Wild -> begin
true
end
| uu____656 -> begin
false
end))


let uu___is_MLP_Const : mlpattern  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLP_Const (_0) -> begin
true
end
| uu____662 -> begin
false
end))


let __proj__MLP_Const__item___0 : mlpattern  ->  mlconstant = (fun projectee -> (match (projectee) with
| MLP_Const (_0) -> begin
_0
end))


let uu___is_MLP_Var : mlpattern  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLP_Var (_0) -> begin
true
end
| uu____676 -> begin
false
end))


let __proj__MLP_Var__item___0 : mlpattern  ->  mlident = (fun projectee -> (match (projectee) with
| MLP_Var (_0) -> begin
_0
end))


let uu___is_MLP_CTor : mlpattern  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLP_CTor (_0) -> begin
true
end
| uu____696 -> begin
false
end))


let __proj__MLP_CTor__item___0 : mlpattern  ->  (mlpath * mlpattern Prims.list) = (fun projectee -> (match (projectee) with
| MLP_CTor (_0) -> begin
_0
end))


let uu___is_MLP_Branch : mlpattern  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLP_Branch (_0) -> begin
true
end
| uu____730 -> begin
false
end))


let __proj__MLP_Branch__item___0 : mlpattern  ->  mlpattern Prims.list = (fun projectee -> (match (projectee) with
| MLP_Branch (_0) -> begin
_0
end))


let uu___is_MLP_Record : mlpattern  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLP_Record (_0) -> begin
true
end
| uu____762 -> begin
false
end))


let __proj__MLP_Record__item___0 : mlpattern  ->  (mlsymbol Prims.list * (mlsymbol * mlpattern) Prims.list) = (fun projectee -> (match (projectee) with
| MLP_Record (_0) -> begin
_0
end))


let uu___is_MLP_Tuple : mlpattern  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLP_Tuple (_0) -> begin
true
end
| uu____814 -> begin
false
end))


let __proj__MLP_Tuple__item___0 : mlpattern  ->  mlpattern Prims.list = (fun projectee -> (match (projectee) with
| MLP_Tuple (_0) -> begin
_0
end))

type meta =
| Mutable
| Assumed
| Private
| NoExtract
| CInline
| Substitute
| GCType
| PpxDerivingShow
| PpxDerivingShowConstant of Prims.string


let uu___is_Mutable : meta  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Mutable -> begin
true
end
| uu____837 -> begin
false
end))


let uu___is_Assumed : meta  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Assumed -> begin
true
end
| uu____842 -> begin
false
end))


let uu___is_Private : meta  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Private -> begin
true
end
| uu____847 -> begin
false
end))


let uu___is_NoExtract : meta  ->  Prims.bool = (fun projectee -> (match (projectee) with
| NoExtract -> begin
true
end
| uu____852 -> begin
false
end))


let uu___is_CInline : meta  ->  Prims.bool = (fun projectee -> (match (projectee) with
| CInline -> begin
true
end
| uu____857 -> begin
false
end))


let uu___is_Substitute : meta  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Substitute -> begin
true
end
| uu____862 -> begin
false
end))


let uu___is_GCType : meta  ->  Prims.bool = (fun projectee -> (match (projectee) with
| GCType -> begin
true
end
| uu____867 -> begin
false
end))


let uu___is_PpxDerivingShow : meta  ->  Prims.bool = (fun projectee -> (match (projectee) with
| PpxDerivingShow -> begin
true
end
| uu____872 -> begin
false
end))


let uu___is_PpxDerivingShowConstant : meta  ->  Prims.bool = (fun projectee -> (match (projectee) with
| PpxDerivingShowConstant (_0) -> begin
true
end
| uu____878 -> begin
false
end))


let __proj__PpxDerivingShowConstant__item___0 : meta  ->  Prims.string = (fun projectee -> (match (projectee) with
| PpxDerivingShowConstant (_0) -> begin
_0
end))


type metadata =
meta Prims.list

type mlletflavor =
| Rec
| NonRec


let uu___is_Rec : mlletflavor  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Rec -> begin
true
end
| uu____893 -> begin
false
end))


let uu___is_NonRec : mlletflavor  ->  Prims.bool = (fun projectee -> (match (projectee) with
| NonRec -> begin
true
end
| uu____898 -> begin
false
end))

type mlexpr' =
| MLE_Const of mlconstant
| MLE_Var of mlident
| MLE_Name of mlpath
| MLE_Let of ((mlletflavor * metadata * mllb Prims.list) * mlexpr)
| MLE_App of (mlexpr * mlexpr Prims.list)
| MLE_Fun of ((mlident * mlty) Prims.list * mlexpr)
| MLE_Match of (mlexpr * (mlpattern * mlexpr FStar_Pervasives_Native.option * mlexpr) Prims.list)
| MLE_Coerce of (mlexpr * mlty * mlty)
| MLE_CTor of (mlpath * mlexpr Prims.list)
| MLE_Seq of mlexpr Prims.list
| MLE_Tuple of mlexpr Prims.list
| MLE_Record of (mlsymbol Prims.list * (mlsymbol * mlexpr) Prims.list)
| MLE_Proj of (mlexpr * mlpath)
| MLE_If of (mlexpr * mlexpr * mlexpr FStar_Pervasives_Native.option)
| MLE_Raise of (mlpath * mlexpr Prims.list)
| MLE_Try of (mlexpr * (mlpattern * mlexpr FStar_Pervasives_Native.option * mlexpr) Prims.list) 
 and mlexpr =
{expr : mlexpr'; mlty : mlty; loc : mlloc} 
 and mllb =
{mllb_name : mlident; mllb_tysc : mltyscheme FStar_Pervasives_Native.option; mllb_add_unit : Prims.bool; mllb_def : mlexpr; print_typ : Prims.bool}


let uu___is_MLE_Const : mlexpr'  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLE_Const (_0) -> begin
true
end
| uu____1104 -> begin
false
end))


let __proj__MLE_Const__item___0 : mlexpr'  ->  mlconstant = (fun projectee -> (match (projectee) with
| MLE_Const (_0) -> begin
_0
end))


let uu___is_MLE_Var : mlexpr'  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLE_Var (_0) -> begin
true
end
| uu____1118 -> begin
false
end))


let __proj__MLE_Var__item___0 : mlexpr'  ->  mlident = (fun projectee -> (match (projectee) with
| MLE_Var (_0) -> begin
_0
end))


let uu___is_MLE_Name : mlexpr'  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLE_Name (_0) -> begin
true
end
| uu____1132 -> begin
false
end))


let __proj__MLE_Name__item___0 : mlexpr'  ->  mlpath = (fun projectee -> (match (projectee) with
| MLE_Name (_0) -> begin
_0
end))


let uu___is_MLE_Let : mlexpr'  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLE_Let (_0) -> begin
true
end
| uu____1158 -> begin
false
end))


let __proj__MLE_Let__item___0 : mlexpr'  ->  ((mlletflavor * metadata * mllb Prims.list) * mlexpr) = (fun projectee -> (match (projectee) with
| MLE_Let (_0) -> begin
_0
end))


let uu___is_MLE_App : mlexpr'  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLE_App (_0) -> begin
true
end
| uu____1214 -> begin
false
end))


let __proj__MLE_App__item___0 : mlexpr'  ->  (mlexpr * mlexpr Prims.list) = (fun projectee -> (match (projectee) with
| MLE_App (_0) -> begin
_0
end))


let uu___is_MLE_Fun : mlexpr'  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLE_Fun (_0) -> begin
true
end
| uu____1256 -> begin
false
end))


let __proj__MLE_Fun__item___0 : mlexpr'  ->  ((mlident * mlty) Prims.list * mlexpr) = (fun projectee -> (match (projectee) with
| MLE_Fun (_0) -> begin
_0
end))


let uu___is_MLE_Match : mlexpr'  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLE_Match (_0) -> begin
true
end
| uu____1314 -> begin
false
end))


let __proj__MLE_Match__item___0 : mlexpr'  ->  (mlexpr * (mlpattern * mlexpr FStar_Pervasives_Native.option * mlexpr) Prims.list) = (fun projectee -> (match (projectee) with
| MLE_Match (_0) -> begin
_0
end))


let uu___is_MLE_Coerce : mlexpr'  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLE_Coerce (_0) -> begin
true
end
| uu____1376 -> begin
false
end))


let __proj__MLE_Coerce__item___0 : mlexpr'  ->  (mlexpr * mlty * mlty) = (fun projectee -> (match (projectee) with
| MLE_Coerce (_0) -> begin
_0
end))


let uu___is_MLE_CTor : mlexpr'  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLE_CTor (_0) -> begin
true
end
| uu____1414 -> begin
false
end))


let __proj__MLE_CTor__item___0 : mlexpr'  ->  (mlpath * mlexpr Prims.list) = (fun projectee -> (match (projectee) with
| MLE_CTor (_0) -> begin
_0
end))


let uu___is_MLE_Seq : mlexpr'  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLE_Seq (_0) -> begin
true
end
| uu____1448 -> begin
false
end))


let __proj__MLE_Seq__item___0 : mlexpr'  ->  mlexpr Prims.list = (fun projectee -> (match (projectee) with
| MLE_Seq (_0) -> begin
_0
end))


let uu___is_MLE_Tuple : mlexpr'  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLE_Tuple (_0) -> begin
true
end
| uu____1470 -> begin
false
end))


let __proj__MLE_Tuple__item___0 : mlexpr'  ->  mlexpr Prims.list = (fun projectee -> (match (projectee) with
| MLE_Tuple (_0) -> begin
_0
end))


let uu___is_MLE_Record : mlexpr'  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLE_Record (_0) -> begin
true
end
| uu____1502 -> begin
false
end))


let __proj__MLE_Record__item___0 : mlexpr'  ->  (mlsymbol Prims.list * (mlsymbol * mlexpr) Prims.list) = (fun projectee -> (match (projectee) with
| MLE_Record (_0) -> begin
_0
end))


let uu___is_MLE_Proj : mlexpr'  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLE_Proj (_0) -> begin
true
end
| uu____1556 -> begin
false
end))


let __proj__MLE_Proj__item___0 : mlexpr'  ->  (mlexpr * mlpath) = (fun projectee -> (match (projectee) with
| MLE_Proj (_0) -> begin
_0
end))


let uu___is_MLE_If : mlexpr'  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLE_If (_0) -> begin
true
end
| uu____1590 -> begin
false
end))


let __proj__MLE_If__item___0 : mlexpr'  ->  (mlexpr * mlexpr * mlexpr FStar_Pervasives_Native.option) = (fun projectee -> (match (projectee) with
| MLE_If (_0) -> begin
_0
end))


let uu___is_MLE_Raise : mlexpr'  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLE_Raise (_0) -> begin
true
end
| uu____1634 -> begin
false
end))


let __proj__MLE_Raise__item___0 : mlexpr'  ->  (mlpath * mlexpr Prims.list) = (fun projectee -> (match (projectee) with
| MLE_Raise (_0) -> begin
_0
end))


let uu___is_MLE_Try : mlexpr'  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLE_Try (_0) -> begin
true
end
| uu____1680 -> begin
false
end))


let __proj__MLE_Try__item___0 : mlexpr'  ->  (mlexpr * (mlpattern * mlexpr FStar_Pervasives_Native.option * mlexpr) Prims.list) = (fun projectee -> (match (projectee) with
| MLE_Try (_0) -> begin
_0
end))


let __proj__Mkmlexpr__item__expr : mlexpr  ->  mlexpr' = (fun projectee -> (match (projectee) with
| {expr = __fname__expr; mlty = __fname__mlty; loc = __fname__loc} -> begin
__fname__expr
end))


let __proj__Mkmlexpr__item__mlty : mlexpr  ->  mlty = (fun projectee -> (match (projectee) with
| {expr = __fname__expr; mlty = __fname__mlty; loc = __fname__loc} -> begin
__fname__mlty
end))


let __proj__Mkmlexpr__item__loc : mlexpr  ->  mlloc = (fun projectee -> (match (projectee) with
| {expr = __fname__expr; mlty = __fname__mlty; loc = __fname__loc} -> begin
__fname__loc
end))


let __proj__Mkmllb__item__mllb_name : mllb  ->  mlident = (fun projectee -> (match (projectee) with
| {mllb_name = __fname__mllb_name; mllb_tysc = __fname__mllb_tysc; mllb_add_unit = __fname__mllb_add_unit; mllb_def = __fname__mllb_def; print_typ = __fname__print_typ} -> begin
__fname__mllb_name
end))


let __proj__Mkmllb__item__mllb_tysc : mllb  ->  mltyscheme FStar_Pervasives_Native.option = (fun projectee -> (match (projectee) with
| {mllb_name = __fname__mllb_name; mllb_tysc = __fname__mllb_tysc; mllb_add_unit = __fname__mllb_add_unit; mllb_def = __fname__mllb_def; print_typ = __fname__print_typ} -> begin
__fname__mllb_tysc
end))


let __proj__Mkmllb__item__mllb_add_unit : mllb  ->  Prims.bool = (fun projectee -> (match (projectee) with
| {mllb_name = __fname__mllb_name; mllb_tysc = __fname__mllb_tysc; mllb_add_unit = __fname__mllb_add_unit; mllb_def = __fname__mllb_def; print_typ = __fname__print_typ} -> begin
__fname__mllb_add_unit
end))


let __proj__Mkmllb__item__mllb_def : mllb  ->  mlexpr = (fun projectee -> (match (projectee) with
| {mllb_name = __fname__mllb_name; mllb_tysc = __fname__mllb_tysc; mllb_add_unit = __fname__mllb_add_unit; mllb_def = __fname__mllb_def; print_typ = __fname__print_typ} -> begin
__fname__mllb_def
end))


let __proj__Mkmllb__item__print_typ : mllb  ->  Prims.bool = (fun projectee -> (match (projectee) with
| {mllb_name = __fname__mllb_name; mllb_tysc = __fname__mllb_tysc; mllb_add_unit = __fname__mllb_add_unit; mllb_def = __fname__mllb_def; print_typ = __fname__print_typ} -> begin
__fname__print_typ
end))


type mlbranch =
(mlpattern * mlexpr FStar_Pervasives_Native.option * mlexpr)


type mlletbinding =
(mlletflavor * metadata * mllb Prims.list)

type mltybody =
| MLTD_Abbrev of mlty
| MLTD_Record of (mlsymbol * mlty) Prims.list
| MLTD_DType of (mlsymbol * (mlsymbol * mlty) Prims.list) Prims.list


let uu___is_MLTD_Abbrev : mltybody  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLTD_Abbrev (_0) -> begin
true
end
| uu____1862 -> begin
false
end))


let __proj__MLTD_Abbrev__item___0 : mltybody  ->  mlty = (fun projectee -> (match (projectee) with
| MLTD_Abbrev (_0) -> begin
_0
end))


let uu___is_MLTD_Record : mltybody  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLTD_Record (_0) -> begin
true
end
| uu____1882 -> begin
false
end))


let __proj__MLTD_Record__item___0 : mltybody  ->  (mlsymbol * mlty) Prims.list = (fun projectee -> (match (projectee) with
| MLTD_Record (_0) -> begin
_0
end))


let uu___is_MLTD_DType : mltybody  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLTD_DType (_0) -> begin
true
end
| uu____1926 -> begin
false
end))


let __proj__MLTD_DType__item___0 : mltybody  ->  (mlsymbol * (mlsymbol * mlty) Prims.list) Prims.list = (fun projectee -> (match (projectee) with
| MLTD_DType (_0) -> begin
_0
end))


type one_mltydecl =
(Prims.bool * mlsymbol * mlsymbol FStar_Pervasives_Native.option * mlidents * metadata * mltybody FStar_Pervasives_Native.option)


type mltydecl =
one_mltydecl Prims.list

type mlmodule1 =
| MLM_Ty of mltydecl
| MLM_Let of mlletbinding
| MLM_Exn of (mlsymbol * (mlsymbol * mlty) Prims.list)
| MLM_Top of mlexpr
| MLM_Loc of mlloc


let uu___is_MLM_Ty : mlmodule1  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLM_Ty (_0) -> begin
true
end
| uu____2024 -> begin
false
end))


let __proj__MLM_Ty__item___0 : mlmodule1  ->  mltydecl = (fun projectee -> (match (projectee) with
| MLM_Ty (_0) -> begin
_0
end))


let uu___is_MLM_Let : mlmodule1  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLM_Let (_0) -> begin
true
end
| uu____2038 -> begin
false
end))


let __proj__MLM_Let__item___0 : mlmodule1  ->  mlletbinding = (fun projectee -> (match (projectee) with
| MLM_Let (_0) -> begin
_0
end))


let uu___is_MLM_Exn : mlmodule1  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLM_Exn (_0) -> begin
true
end
| uu____2062 -> begin
false
end))


let __proj__MLM_Exn__item___0 : mlmodule1  ->  (mlsymbol * (mlsymbol * mlty) Prims.list) = (fun projectee -> (match (projectee) with
| MLM_Exn (_0) -> begin
_0
end))


let uu___is_MLM_Top : mlmodule1  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLM_Top (_0) -> begin
true
end
| uu____2106 -> begin
false
end))


let __proj__MLM_Top__item___0 : mlmodule1  ->  mlexpr = (fun projectee -> (match (projectee) with
| MLM_Top (_0) -> begin
_0
end))


let uu___is_MLM_Loc : mlmodule1  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLM_Loc (_0) -> begin
true
end
| uu____2120 -> begin
false
end))


let __proj__MLM_Loc__item___0 : mlmodule1  ->  mlloc = (fun projectee -> (match (projectee) with
| MLM_Loc (_0) -> begin
_0
end))


type mlmodule =
mlmodule1 Prims.list

type mlsig1 =
| MLS_Mod of (mlsymbol * mlsig1 Prims.list)
| MLS_Ty of mltydecl
| MLS_Val of (mlsymbol * mltyscheme)
| MLS_Exn of (mlsymbol * mlty Prims.list)


let uu___is_MLS_Mod : mlsig1  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLS_Mod (_0) -> begin
true
end
| uu____2174 -> begin
false
end))


let __proj__MLS_Mod__item___0 : mlsig1  ->  (mlsymbol * mlsig1 Prims.list) = (fun projectee -> (match (projectee) with
| MLS_Mod (_0) -> begin
_0
end))


let uu___is_MLS_Ty : mlsig1  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLS_Ty (_0) -> begin
true
end
| uu____2206 -> begin
false
end))


let __proj__MLS_Ty__item___0 : mlsig1  ->  mltydecl = (fun projectee -> (match (projectee) with
| MLS_Ty (_0) -> begin
_0
end))


let uu___is_MLS_Val : mlsig1  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLS_Val (_0) -> begin
true
end
| uu____2224 -> begin
false
end))


let __proj__MLS_Val__item___0 : mlsig1  ->  (mlsymbol * mltyscheme) = (fun projectee -> (match (projectee) with
| MLS_Val (_0) -> begin
_0
end))


let uu___is_MLS_Exn : mlsig1  ->  Prims.bool = (fun projectee -> (match (projectee) with
| MLS_Exn (_0) -> begin
true
end
| uu____2256 -> begin
false
end))


let __proj__MLS_Exn__item___0 : mlsig1  ->  (mlsymbol * mlty Prims.list) = (fun projectee -> (match (projectee) with
| MLS_Exn (_0) -> begin
_0
end))


type mlsig =
mlsig1 Prims.list


let with_ty_loc : mlty  ->  mlexpr'  ->  mlloc  ->  mlexpr = (fun t e l -> {expr = e; mlty = t; loc = l})


let with_ty : mlty  ->  mlexpr'  ->  mlexpr = (fun t e -> (with_ty_loc t e dummy_loc))

type mllib =
| MLLib of (mlpath * (mlsig * mlmodule) FStar_Pervasives_Native.option * mllib) Prims.list


let uu___is_MLLib : mllib  ->  Prims.bool = (fun projectee -> true)


let __proj__MLLib__item___0 : mllib  ->  (mlpath * (mlsig * mlmodule) FStar_Pervasives_Native.option * mllib) Prims.list = (fun projectee -> (match (projectee) with
| MLLib (_0) -> begin
_0
end))


let ml_unit_ty : mlty = MLTY_Named ((([]), (((("Prims")::[]), ("unit")))))


let ml_bool_ty : mlty = MLTY_Named ((([]), (((("Prims")::[]), ("bool")))))


let ml_int_ty : mlty = MLTY_Named ((([]), (((("Prims")::[]), ("int")))))


let ml_string_ty : mlty = MLTY_Named ((([]), (((("Prims")::[]), ("string")))))


let ml_unit : mlexpr = (with_ty ml_unit_ty (MLE_Const (MLC_Unit)))


let mlp_lalloc : (Prims.string Prims.list * Prims.string) = ((("SST")::[]), ("lalloc"))


let apply_obj_repr : mlexpr  ->  mlty  ->  mlexpr = (fun x t -> (

let obj_repr = (with_ty (MLTY_Fun (((t), (E_PURE), (MLTY_Top)))) (MLE_Name (((("Obj")::[]), ("repr")))))
in (with_ty_loc MLTY_Top (MLE_App (((obj_repr), ((x)::[])))) x.loc)))


let avoid_keyword : Prims.string  ->  Prims.string = (fun s -> (match ((is_reserved s)) with
| true -> begin
(Prims.strcat s "_")
end
| uu____2439 -> begin
s
end))


let bv_as_mlident : FStar_Syntax_Syntax.bv  ->  mlident = (fun x -> (

let uu____2444 = (((FStar_Util.starts_with x.FStar_Syntax_Syntax.ppname.FStar_Ident.idText FStar_Ident.reserved_prefix) || (FStar_Syntax_Syntax.is_null_bv x)) || (is_reserved x.FStar_Syntax_Syntax.ppname.FStar_Ident.idText))
in (match (uu____2444) with
| true -> begin
(

let uu____2445 = (

let uu____2446 = (

let uu____2447 = (FStar_Util.string_of_int x.FStar_Syntax_Syntax.index)
in (Prims.strcat "_" uu____2447))
in (Prims.strcat x.FStar_Syntax_Syntax.ppname.FStar_Ident.idText uu____2446))
in ((uu____2445), ((Prims.parse_int "0"))))
end
| uu____2448 -> begin
((x.FStar_Syntax_Syntax.ppname.FStar_Ident.idText), ((Prims.parse_int "0")))
end)))


let push_unit : mltyscheme  ->  mltyscheme = (fun ts -> (

let uu____2453 = ts
in (match (uu____2453) with
| (vs, ty) -> begin
((vs), (MLTY_Fun (((ml_unit_ty), (E_PURE), (ty)))))
end)))


let pop_unit : mltyscheme  ->  mltyscheme = (fun ts -> (

let uu____2460 = ts
in (match (uu____2460) with
| (vs, ty) -> begin
(match (ty) with
| MLTY_Fun (l, E_PURE, t) -> begin
(match ((l = ml_unit_ty)) with
| true -> begin
((vs), (t))
end
| uu____2465 -> begin
(failwith "unexpected: pop_unit: domain was not unit")
end)
end
| uu____2466 -> begin
(failwith "unexpected: pop_unit: not a function type")
end)
end)))




