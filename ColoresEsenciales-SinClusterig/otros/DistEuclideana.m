function r = DistEuclideana(p1, p2)
     p1 = double(p1);
     p2 = double(p2);
     r(1) = (abs(p1(1) - p2(1)))^2;
     r(2) = (abs(p1(2) - p2(2)))^2;
     r(3) = (abs(p1(3) - p2(3)))^2;
     r = sqrt(r(1) + r(2) + r(3));
end