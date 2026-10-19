# G2(8) built independently from the 7-dim Chevalley lattice of the G2 Lie algebra
# (divided powers of root elements, reduced to GF(8)); order check and a random sample
# of element orders (evidence only; the proof for G2(8) is in solution.md, Section 8.3).
NSAMP := 3000;; DOSIZE := true;;
L := SimpleLieAlgebra("G", 2, Rationals);;
ch := ChevalleyBasis(L);;
V := HighestWeightModule(L, [1,0]);;
B := Basis(V);;
mat := x -> TransposedMat(List(B, v -> Coefficients(B, x^v)));;  # acts on column vectors
RE := List(Concatenation(ch[1], ch[2]), mat);;
Print("num root elts ", Length(RE), "\n");
ok := true;;
for e in RE do
  k := 1; P := e;
  while not IsZero(P) do
    if not ForAll(Flat(P/Factorial(k)), IsInt) then ok := false; fi;
    k := k + 1; P := P * e;
  od;
od;
Print("divided powers integral: ", ok, "\n");
F := GF(8);; z := Z(8);;
xa := function(e, t)
  local k, P, M;
  M := IdentityMat(7, F); k := 1; P := e;
  while not IsZero(P) do
    M := M + t^k * (P/Factorial(k)) * One(F); k := k + 1; P := P*e;
  od;
  return M;
end;;
gens := [];;
for i in [1, 2, 7, 8] do
  Add(gens, xa(RE[i], z)); Add(gens, xa(RE[i], One(F)));
od;
G := Group(gens);;
om := n -> Length(Set(Factors(n)));;
S := [];;
for i in [1..NSAMP] do AddSet(S, Order(PseudoRandom(G))); od;
Print("orders seen: ", S, "\n");
Print("bad: ", Filtered(S, x -> x > 1 and om(x) >= 3), "\n");
if DOSIZE then Print("size ", Size(G), " expected ", 8^6*(8^6-1)*(8^2-1), "\n"); fi;
QUIT;
