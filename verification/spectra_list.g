# Maximal element orders (w.r.t. divisibility) of the sporadic and the "finite list"
# groups with property (P2), from the GAP character table library.
LoadPackage("ctbllib");
SizeScreen([4096, 100]);
names := ["M11","M12","M22","M23","M24","J1","J2","J3","HS","He","Ru","Suz","ON",
  "L4(3)","L5(2)","U4(2)","U4(3)","U5(2)","U6(2)","S4(4)","S4(8)","S6(2)","O7(3)",
  "O8+(2)","O8+(3)","G2(3)","G2(4)","3D4(2)","2F4(2)'","2F4(8)"];
for nm in names do
  o := Set(OrdersClassRepresentatives(CharacterTable(nm)));
  mu := Filtered(o, a -> not ForAny(o, b -> b <> a and b mod a = 0));
  Print(nm, " : mu = ", mu, "\n");
od;
QUIT;
