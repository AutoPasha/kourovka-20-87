# Validation of torus_method.g against the GAP character table library.
# For each test case: compute (P2) by the torus method, and compare with the verdict
# obtained from the character table (OrdersClassRepresentatives) when the table exists.
# Also check Steinberg's count of F-stable maximal tori: the implied |G_sc^F| divided by |T|
# must equal |Z(G_sc^F)|.
LoadPackage("ctbllib");
Read("torus_method.g");

A := function(n) return PermList(List([1..n], i -> n + 1 - i)); end;
D4aut := DiagramAuts(RootDatum("D", 4).C);
tri := First(D4aut, g -> Order(g) = 3);
inv := First(D4aut, g -> Order(g) = 2);
E6aut := First(DiagramAuts(RootDatum("E", 6).C), g -> Order(g) = 2);
Dn2 := n -> First(DiagramAuts(RootDatum("D", n).C), g -> Order(g) = 2);

# [ table name, type, rank, q, twist, p-part exponent factor (|G|_p = q^(N*e)) ]
cases := [
 ["L2(8)","A",1,8,"none",1], ["L2(11)","A",1,11,"none",1], ["L2(16)","A",1,16,"none",1],
 ["L2(31)","A",1,31,"none",1], ["L2(59)","A",1,59,"none",1], ["L2(61)","A",1,61,"none",1],
 ["L3(2)","A",2,2,"none",1], ["L3(3)","A",2,3,"none",1], ["L3(4)","A",2,4,"none",1],
 ["L3(5)","A",2,5,"none",1], ["L3(7)","A",2,7,"none",1], ["L3(8)","A",2,8,"none",1],
 ["L3(9)","A",2,9,"none",1], ["L3(11)","A",2,11,"none",1],
 ["U3(3)","A",2,3,A(2),1], ["U3(4)","A",2,4,A(2),1], ["U3(5)","A",2,5,A(2),1],
 ["U3(7)","A",2,7,A(2),1], ["U3(8)","A",2,8,A(2),1], ["U3(9)","A",2,9,A(2),1],
 ["U3(11)","A",2,11,A(2),1],
 ["L4(3)","A",3,3,"none",1], ["L4(4)","A",3,4,"none",1], ["L5(2)","A",4,2,"none",1],
 ["L5(3)","A",4,3,"none",1], ["L6(2)","A",5,2,"none",1],
 ["U4(2)","A",3,2,A(3),1], ["U4(3)","A",3,3,A(3),1], ["U4(4)","A",3,4,A(3),1],
 ["U5(2)","A",4,2,A(4),1], ["U5(3)","A",4,3,A(4),1], ["U6(2)","A",5,2,A(5),1],
 ["S4(4)","C",2,4,"none",1], ["S4(5)","C",2,5,"none",1], ["S4(7)","C",2,7,"none",1],
 ["S4(8)","C",2,8,"none",1], ["S6(2)","C",3,2,"none",1], ["S6(3)","C",3,3,"none",1],
 ["S8(2)","C",4,2,"none",1], ["O7(3)","B",3,3,"none",1],
 ["O8+(2)","D",4,2,"none",1], ["O8+(3)","D",4,3,"none",1],
 ["O8-(2)","D",4,2,inv,1], ["O8-(3)","D",4,3,inv,1],
 ["G2(3)","G",2,3,"none",1], ["G2(4)","G",2,4,"none",1], ["G2(5)","G",2,5,"none",1],
 ["G2(8)","G",2,8,"none",1],
 ["3D4(2)","D",4,2,tri,1], ["3D4(3)","D",4,3,tri,1],
 ["Sz(8)","C",2,8,"ree",1/2], ["Sz(32)","C",2,32,"ree",1/2],
 ["R(27)","G",2,27,"ree",1/2],
 ["2F4(8)","F",4,8,"ree",1/2],
 ["F4(2)","F",4,2,"none",1]
];

for c in cases do
  R := LieP2(c[2], c[3], c[4], c[5]);
  v := ReportP2(Concatenation(c[1], " [torus method]"), R);
  impl := ImpliedOrder(R, c[4]^(R.N * c[6]));
  t := CharacterTable(c[1]);
  if t <> fail then
    tv := ForAll(OrdersClassRepresentatives(t), o -> omega(o) <= 2);
    Print("    table verdict = ", tv, " ; agree = ", tv = v,
          " ; implied |G_sc^F| / |T| = ", impl / Size(t), "\n");
  else
    Print("    no table ; implied |G_sc^F| = ", impl, " = ", Collected(Factors(impl)), "\n");
  fi;
od;
QUIT;
