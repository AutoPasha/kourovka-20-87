# Torus-method verdicts for the remaining base cases of Section 8.1 that were decided
# by character tables (independent confirmation): U7(2), S6(4), O9(3), O10+(2), O10-(2),
# O10+(3), O10-(3).
Read("torus_method.g");
A := function(n) return PermList(List([1..n], i -> n + 1 - i)); end;
D5inv := First(DiagramAuts(RootDatum("D", 5).C), g -> Order(g) = 2);
ReportP2("U7(2)", LieP2("A", 6, 2, A(6)));
ReportP2("S6(4)", LieP2("C", 3, 4, "none"));
ReportP2("O9(3)", LieP2("B", 4, 3, "none"));
ReportP2("O10+(2)", LieP2("D", 5, 2, "none"));
ReportP2("O10-(2)", LieP2("D", 5, 2, D5inv));
ReportP2("O10+(3)", LieP2("D", 5, 3, "none"));
ReportP2("O10-(3)", LieP2("D", 5, 3, D5inv));
QUIT;
