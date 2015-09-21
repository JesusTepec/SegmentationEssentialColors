function  dE = CIE2000(p1, p2)
        L1 = p1(:,:,1);
        a1 = p1(:,:,2) - 127;
        b1 = p1(:,:,3) - 127;
        L2 = p2(:,:,1);
        a2 = p2(:,:,2) - 127;
        b2 = p2(:,:,3) - 127;
        mLA = (L1 + L2) / 2;
        C1 = sqrt((a1^2) + (b1^2));
        C2 = sqrt((a2^2) + (b2^2));
        mC = (C1+C2) / 2;
        G = (1 - sqrt((mC^7) /(mC^7) + (25^7))) / 2;
        a1A = a1 * (1 + G);
        a2A = a2 * (1 + G);
        C1A = sqrt(a1A^2 + b1^2);
        C2A = sqrt(a2A^2 + b2^2);
        mCA = (C1A + C2A) / 2;
        if (a1A == 0)
           a1A = 0.000001;
        end
        h1A = atan2(b1, a1A) * (180 / pi);
        if (h1A < 0)
           h1A = h1A + 360;
        end
        if (a2A==0)
           a2A = 0.000001;
        end
        h2A = atan2(b2, a2A) * (180 / pi);
        if (h2A < 0)
           h2A = h2A + 360;
        end
        if (abs(h1A - h2A) > 180)
           mHA = (h1A + h2A + 360) / 2;
        else
           mHA = (h1A + h2A)/ 2;
           T = 1 - (0.17 * cos((mHA - 30) * (pi / 180))) + (0.24 * cos((2 * mHA) * (pi / 180)))+(0.32 * cos(((3 * mHA) + 6)*(pi / 180)))-(0.20 * cos(((4 * mHA) - 63)*(pi / 180)));
        end
        if (abs(h2A - h1A) <= 180)
           dhmA = h2A - h1A;
        else
            if (h2A<=h1A)
                dhmA=h2A-h1A+360;
            else
                dhmA=h2A-h1A-360;
            end
        end
                
        dLA = L2 - L1;
        dCA = C2A - C1A;
        dHA = 2 * sqrt(C1A * C2A) * (sin((dhmA*(pi / 180)) / 2));
        Sl = 1 + (0.015 * sqrt(mLA - 50)) / sqrt(20 + (mLA - 50)^2);
        Sc = 1 + 0.045 * mCA;
        Sh = 1 + 0.015 * mCA * T;
        dGrados = 30 * exp(-1 * ((mHA-275)/25)^2);
        Rc = sqrt((mCA)^7/((mCA)^7 + (25)^7));
        Rt = (-2)* Rc *(sin(2 * dGrados*(pi / 180)));
        
        dE = sqrt((dLA / Sl)^2+ (dCA/Sc)^2 + (dHA / Sh)^2 + (Rt * (dCA/Sc)*(dHA/Sh)));
    
end