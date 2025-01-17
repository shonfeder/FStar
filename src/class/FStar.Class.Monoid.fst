module FStar.Class.Monoid

open FStar.Compiler
open FStar.Compiler.Effect
open FStar.Compiler.List

class monoid (a:Type) = {
   mzero : a;
   mplus : a -> a -> a;
}

val msum (#a:Type) {|monoid a|} (xs:list a) : a
let msum xs = fold_left mplus mzero xs

instance monoid_int : monoid int = {
   mzero = 0;
   mplus = (fun x y -> x + y);
}

instance monoid_string : monoid string = {
   mzero = "";
   mplus = (fun x y -> x ^ y);
}

instance monoid_list (a:Type) : Tot (monoid (list a)) = {
   mzero = [];
   mplus = (fun x y -> x @ y);
}

instance monoid_set (a:Type) : Tot (monoid (Util.set a)) = {
   mzero = Set.empty;
   mplus = Set.union;
}

(* Funny output from Copilot... not bad!

instance monoid_effect (a:Type) (e:effect) : monoid (a!e) = {
   mzero = return mzero;
   mplus = (fun x y -> x >>= (fun x -> y >>= (fun y -> return (mplus x y))));
}

*)
