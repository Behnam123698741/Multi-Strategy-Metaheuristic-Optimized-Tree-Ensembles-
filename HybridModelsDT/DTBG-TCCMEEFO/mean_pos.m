function mean_pop=mean_pos(pop) 

    nVar = numel(pop(1).Position);
    nPop = numel(pop);
    
    pp_vector = [pop.Position];

    pp_mt=reshape(pp_vector,[nVar,nPop]);

%     pp_m = pp_mt';
    mean_pop = mean(pp_mt');

end