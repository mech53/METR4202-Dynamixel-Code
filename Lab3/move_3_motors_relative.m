function move_3_motors_relative(currentpos, desiredpos)
%   move_3_motors_relative(currentpos, desiredpos)
%   Conventions of the input:
%   currentpos = [theta1, theta2, theta3] in order of ID 1, 2, 3
%   desiredpos = [id1, theta1, id2, theta2, id3, theta3]

new_desiredpos = zeros(1, 3);

for i = 1:2:6
    if desiredpos(i) == 1
        new_desiredpos(1) = desiredpos(i+1);
    end
    if desiredpos(i) == 2
        new_desiredpos(2) = desiredpos(i+1);
    end
    if desiredpos(i) == 3
        new_desiredpos(3) = desiredpos(i+1);
    end
end

%   If the difference in angles is too great, we need to do it in
%   increments.

%       UNFINISHED

end