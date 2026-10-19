# Scan all simple non-abelian groups whose character tables are in ctbllib.
# For each such table compute the maximal number of distinct prime divisors of an element order
# (element orders = OrdersClassRepresentatives).
# Prints: GOOD name, prime divisors of |G|, element orders   (if every element order has <=2 prime divisors)
#         BAD  name, an element order with >=3 prime divisors
LoadPackage("ctbllib");
omega := n -> Length(Set(Filtered(Factors(n), x -> x > 1)));
names := AllCharacterTableNames();;
good := [];; bad := [];; seen := [];;
for nm in names do
  t := CharacterTable(nm);
  if t = fail then continue; fi;
  if IsDuplicateTable(t) then continue; fi;
  if not IsSimpleCharacterTable(t) or IsAbelian(t) then continue; fi;
  if Identifier(t) in seen then continue; fi;
  Add(seen, Identifier(t));
  ords := Set(OrdersClassRepresentatives(t));
  m := Maximum(List(ords, omega));
  if m <= 2 then
    Add(good, [Identifier(t), Size(t), ords]);
  else
    Add(bad, [Identifier(t), First(ords, o -> omega(o) >= 3)]);
  fi;
od;
Print("NUMBER OF NONABELIAN SIMPLE TABLES SCANNED: ", Length(seen), "\n");
Print("GOOD count: ", Length(good), "\n");
for x in good do
  Print("GOOD ", x[1], " |G|primes=", Set(Factors(x[2])), " orders=", x[3], "\n");
od;
Print("BAD count: ", Length(bad), "\n");
for x in bad do Print("BAD ", x[1], " witness ", x[2], "\n"); od;
QUIT;
