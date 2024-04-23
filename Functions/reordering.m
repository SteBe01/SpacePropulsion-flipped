function [vect] = reordering(vect)

maxVal1 = max(vect(:,1));
maxVal2 = max(vect(:,2));
maxVal3 = max(vect(:,3));

if maxVal3 < maxVal2 && maxVal3 > maxVal1
    dummy = vect(:,3);
    vect(:,3) = vect(:,2);
    vect(:,2) = dummy;
end

end
