# Orders |sZ|>1 of semisimple elements s with a nontrivial unipotent element in C(s),
# for G2(8), 2F4(8), Sp4(8) (statements in solution.md, Sections 8.2-8.3)
Read("torus_method.g");
COLLECT := true;
for c in [["G2(8)","G",2,8,"none"], ["2F4(8)","F",4,8,"ree"], ["S4(8)","C",2,8,"none"]] do
  MIXSET := [];
  R := LieP2(c[2], c[3], c[4], c[5]);
  Print(c[1], ": torus orders ", Set(R.tori), " ; orders of s with Phi_s nonempty: ", MIXSET, "\n");
od;
QUIT;
