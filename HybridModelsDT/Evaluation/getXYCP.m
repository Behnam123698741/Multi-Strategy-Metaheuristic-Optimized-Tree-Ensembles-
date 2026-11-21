function [y, idx] = getXYCP(y)

    % y = zeros(size(HMOutput.SearchHistory,2),1);
    % 
    % 
    % for i=1:size(HMOutput.BESTSOLUTION,2)
    %     y(i) = HMOutput.BESTSOLUTION(i).Cost;
    % end


    idx = find(y==0); 
    if numel(idx)~=0
        idx = idx(1);
        y(idx:end) = y(idx-1);
        idx = [];
    else
        idx = [];
    end

    if size(y,2)>1
        y = y';
    end

    if size(y,1)>200
        y = y(1:200);
    end

    if size(idx,2)>1
        idx = idx';
    end

end
