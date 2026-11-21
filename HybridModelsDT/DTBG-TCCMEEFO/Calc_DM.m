function Vpop = Calc_DM(pop) 

    nVar = numel(pop(1).Position);
    nPop = numel(pop);
    
    pp_vector = [pop.Position];
    pp_mt=reshape(pp_vector,[nVar,nPop]);
    sc_pop = iqr(pp_mt');

    Vpop = 1;
    for i=1:numel(sc_pop)
        if sc_pop(i)~=0
            Vpop = Vpop* (2*sc_pop(i));
        end
        
    end

end