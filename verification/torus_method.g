#############################################################################
##  torus_method.g  --  decide property (P2) for a finite simple group of Lie type
##  T = G_sc^F / Z(G_sc^F), using only the root datum.
##
##  (P2): no element order is divisible by three distinct primes.
##
##  Theory used (see solution.md, Section 5):
##   * g = su (Jordan decomposition), |gZ| = |sZ| * |u|  (Z is a p'-group).
##   * every semisimple s lies in an F-stable maximal torus T_w; T_w^F = (F_w-1)^{-1}Y / Y
##     inside Y (x) Q/Z, where Y = coroot lattice (G simply connected) and F_w = F o w on Y.
##   * for s <-> v,  alpha(s)=1  iff  <alpha,v> in Z;  |sZ| = order of v modulo the
##     coweight lattice  (i.e. lcm of denominators of <alpha_i,v>, alpha_i simple).
##   * C_G(s) is connected (Steinberg) and contains a nontrivial unipotent F-fixed element
##     iff  Phi_s = {alpha : alpha(s)=1} is nonempty.
##  Hence (P2) <=> for all w and all v in T_w^F:
##        omega(|sZ|) <= 2,   and   omega(|sZ|) <= 1 whenever Phi_s is nonempty.
#############################################################################

omega := n -> Length(Set(Filtered(Factors(n), x -> x > 1)));

# root data: Cartan matrix C (rows = simple roots as weights, C[i][j] = <alpha_i, alpha_j^vee>),
# all roots as weight vectors (entries <alpha, alpha_j^vee>)
RootDatum := function(type, n)
  local L, R, C, pos;
  L := SimpleLieAlgebra(type, n, Rationals);
  R := RootSystem(L);
  C := CartanMatrix(R);
  pos := PositiveRoots(R);
  return rec(C := C, roots := Concatenation(pos, -pos), r := n, N := Length(pos),
             len := List([1..n], i -> BilinearFormMat(R)[i][i]));
end;

# reflections on Y (column vectors of coefficients w.r.t. simple coroots)
WeylOnY := function(rd)
  local r, gens, i, S, k;
  r := rd.r; gens := [];
  for i in [1..r] do
    S := IdentityMat(r);
    S := List(S, ShallowCopy);
    for k in [1..r] do S[i][k] := S[i][k] - rd.C[i][k]; od;
    Add(gens, S);
  od;
  return Group(gens);
end;

# permutation matrix of a diagram symmetry rho (list): e_i -> e_{rho(i)} (column action)
PermMat := function(rho)
  local r, M, i;
  r := Length(rho);
  M := NullMat(r, r);
  for i in [1..r] do M[rho[i]][i] := 1; od;
  return M;
end;

# diagram automorphisms of the Cartan matrix
DiagramAuts := function(C)
  local r;
  r := Length(C);
  return Filtered(SymmetricGroup(r), g ->
           ForAll([1..r], i -> ForAll([1..r], j -> C[i^g][j^g] = C[i][j])));
end;

# long/short swap for Suzuki-Ree: rho with C[rho i][rho j] = C[j][i]
SwapRho := function(C)
  local r;
  r := Length(C);
  return First(SymmetricGroup(r), g ->
           ForAll([1..r], i -> ForAll([1..r], j -> C[i^g][j^g] = C[j][i])));
end;

# if COLLECT = true, the orders |sZ| > 1 of all semisimple s with Phi_s nonempty are
# collected in the global set MIXSET (used for the statements about G2(8), 2F4(8))
COLLECT := false; MIXSET := [];

# analyse the torus with Frobenius matrix M on Y (column action)
AnalyseTorus := function(rd, M)
  local r, D, snf, Nd, Q, ord, tuples, res, k, v, w, a, phi, o, maxss, maxmix, wss, wmix;
  r := rd.r;
  D := M - IdentityMat(r);
  snf := SmithNormalFormIntegerMatTransforms(D);
  Nd := List([1..r], i -> AbsInt(snf.normal[i][i]));
  Q := snf.coltrans;
  maxss := 0; maxmix := 0; wss := 1; wmix := 1;
  for k in Cartesian(List(Nd, n -> [0..n-1])) do
    v := Q * List([1..r], i -> k[i] / Nd[i]);      # element of (D^-1 Z^r)/Z^r
    w := rd.C * v;                                  # <alpha_i, v>
    o := Lcm(List(w, DenominatorRat));              # order of sZ in the adjoint quotient
    if o = 1 then continue; fi;
    a := omega(o);
    if a > maxss then maxss := a; wss := o; fi;
    if a > maxmix or COLLECT then
      phi := ForAny(rd.roots, al -> IsInt(al * v));
      if phi and a > maxmix then maxmix := a; wmix := o; fi;
      if phi and COLLECT then AddSet(MIXSET, o); fi;
    fi;
  od;
  return rec(order := Product(Nd), maxss := maxss, wss := wss, maxmix := maxmix, wmix := wmix);
end;

# main routine.
#  twist = "none" : untwisted, F = q*w
#  twist = perm rho (graph automorphism) : F = q * w * sigma
#  twist = "ree"  : Suzuki/Ree, q = p^(2m+1), F = p^m * w * tau
LieP2 := function(type, n, q, twist)
  local rd, W, Sg, G, cls, reps, sizes, res, best, M, x, tau, rho, p, m, i, total, tor, ccl;
  rd := RootDatum(type, n);
  W := WeylOnY(rd);
  if twist = "none" then
    Sg := IdentityMat(n);
  elif twist = "ree" then
    rho := SwapRho(rd.C);
    p := Factors(q)[1];        # q = p^(2m+1)
    m := (Length(Factors(q)) - 1) / 2;
    tau := NullMat(n, n);
    for i in [1..n] do
      # alpha_i long root  <=>  alpha_i^vee short coroot  : tau(alpha_i^vee) = alpha_{rho i}^vee
      # alpha_i short root <=>  alpha_i^vee long coroot  : tau(alpha_i^vee) = p * alpha_{rho i}^vee
      if rd.len[i] < Maximum(rd.len) then   # alpha_i short root : alpha_i^vee long coroot
        tau[i^rho][i] := p;
      else
        tau[i^rho][i] := 1;
      fi;
    od;
    Sg := tau;
  else
    Sg := PermMat(ListPerm(twist, n));
  fi;
  # F-classes: W-orbits on the coset W*Sg (conjugation); use classes of <W,Sg> meeting coset
  if twist = "none" then
    ccl := ConjugacyClasses(W);
    reps := List(ccl, c -> Representative(c));
    sizes := List(ccl, Size);
  else
    # coset elements w*Sg ; orbits of W under x -> y x Sg(y)^-1 , i.e. conjugation of w*Sg by y
    ccl := [];
    reps := []; sizes := [];
    tor := Set(List(AsList(W), w -> w * Sg));
    while Length(tor) > 0 do
      x := tor[1];
      ccl := Set(List(AsList(W), y -> y * x * y^-1));
      Add(reps, x * Sg^-1); Add(sizes, Length(ccl));
      SubtractSet(tor, ccl);
    od;
  fi;
  res := [];
  total := 0;
  for i in [1..Length(reps)] do
    if twist = "ree" then
      M := p^m * reps[i] * Sg;
    else
      M := q * reps[i] * Sg;
    fi;
    x := AnalyseTorus(rd, M);
    Add(res, x);
    total := total + sizes[i] / x.order;
  od;
  # Steinberg: number of F-stable maximal tori = |G^F|_p^2 ; gives |G_sc^F| = |G|_p^2 * |W| / sum
  return rec(tori := List(res, x -> x.order), maxss := Maximum(List(res, x -> x.maxss)),
             maxmix := Maximum(List(res, x -> x.maxmix)),
             wss := List(Filtered(res, x -> x.maxss >= 3), x -> x.wss),
             wmix := List(Filtered(res, x -> x.maxmix >= 2), x -> x.wmix),
             sumInv := total, W := Size(W), N := rd.N);
end;

# order of G_sc^F implied by Steinberg's count  (for checking): |G|_p = q^N (for Ree: q^N/ ... handled by caller)
ImpliedOrder := function(R, pPart)
  return pPart^2 * R.W / R.sumInv;
end;

ReportP2 := function(name, R)
  local verdict;
  verdict := (R.maxss <= 2) and (R.maxmix <= 1);
  Print(name, ": torus orders ", Set(R.tori), "; max omega(ss) = ", R.maxss,
        "; max omega(s) with unipotent centraliser = ", R.maxmix,
        "; (P2) = ", verdict);
  if not verdict then Print("  witnesses ss ", Set(R.wss), " mixed(s-part) ", Set(R.wmix)); fi;
  Print("\n");
  return verdict;
end;
