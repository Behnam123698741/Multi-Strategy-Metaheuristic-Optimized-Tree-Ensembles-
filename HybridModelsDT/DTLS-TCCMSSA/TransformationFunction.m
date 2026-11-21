% TransformationFunction
function Position = TransformationFunction(Position)

    % Convert the position of continious individual into binary ones using
    % Eq. (4.3.1) or Eq. (4.3.2)
    % S-shaped
    Xt=1./(1+exp(-10.*(-Position)));
    % V-shaped
    % Xt=abs(tanh(Position));

    % Position update
    v_rb = rand(1,numel(Position));   % Random in [0,1]
    idx0 = find(Xt<v_rb);
    idx1 = find(Xt>=v_rb);
        
    Position(idx0) = 0;
    Position(idx1) = 1;

end
