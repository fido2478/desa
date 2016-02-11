function load_demand=generate_loads(dis_type,lower_demand,upper_demand,max_runtime,maxreC,nomcells,interval)

switch dis_type
    case 'rand'
        load_demand=loadfile('dat/log/load_demand-rand.txt','%d ', [1 Inf]);
        if isempty(load_demand) | load_demand<0
            load_demand=lower_demand;
            for i=2:max_runtime
                derivative=load_demand(i-1)+lower_demand*normrnd(0,1);
                if derivative > upper_demand
                    derivative=upper_demand;
                elseif derivative < lower_demand
                    derivative=lower_demand;
                end
                load_demand=[load_demand derivative];
            end
            if savefile(load_demand,'%d ','dat/log/load_demand.txt')<0
                return;
            end
        end
    case 'const1'
        load_demand=loadfile('dat/log/load_demand-const10.txt','%d ', [1 Inf]);
        if isempty(load_demand) | load_demand<0
            load_demand=lower_demand;
            upper_demand=maxreC(1)*(round(nomcells*0.5)); %coulomb
            for i=2:round(max_runtime*0.05)
                derivative=load_demand(i-1)+(lower_demand*rand);
                if derivative > upper_demand
                    derivative=upper_demand;
                end
                load_demand=[load_demand derivative];
            end
            for i=round(max_runtime*0.05)+1:max_runtime
                derivative=load_demand(i-1)-(lower_demand*rand);
                if derivative < lower_demand
                    derivative=lower_demand;
                end
                load_demand=[load_demand derivative];
            end
            if savefile(load_demand,'%d ','dat/log/load_demand.txt')<0
                return;
            end
        end
    case 'const2'
        load_demand=loadfile('dat/log/load_demand-const20.txt','%d ', [1 Inf]);
        if isempty(load_demand) | load_demand<0
            load_demand=lower_demand;
            upper_demand=maxreC(2)*(round(nomcells*0.5));
            for i=2:round(max_runtime*0.05)
                derivative=load_demand(i-1)+(lower_demand*rand);
                if derivative > upper_demand
                    derivative=upper_demand;
                end
                load_demand=[load_demand derivative];
            end
            for i=round(max_runtime*0.05)+1:max_runtime
                derivative=load_demand(i-1)-(lower_demand*rand);
                if derivative < lower_demand
                    derivative=lower_demand;
                end
                load_demand=[load_demand derivative];
            end
            if savefile(load_demand,'%d ','dat/log/load_demand.txt')<0
                return;
            end
        end
    case 'const3'
        load_demand=loadfile('dat/log/load_demand-const30.txt','%d ', [1 Inf]);
        if isempty(load_demand) | load_demand<0
            load_demand=lower_demand;
            upper_demand=maxreC(1)*(round(nomcells*0.5));
            for i=2:round(max_runtime*0.05)
                derivative=load_demand(i-1)+(lower_demand*rand);
                if derivative > upper_demand
                    derivative=upper_demand;
                end
                load_demand=[load_demand derivative];
            end
            for i=round(max_runtime*0.05)+1:2*round(max_runtime*0.05)
                derivative=load_demand(i-1)-(lower_demand*rand);
                if derivative < lower_demand
                    derivative=lower_demand;
                end
                load_demand=[load_demand derivative];
            end
            for i=2*round(max_runtime*0.05)+1:3*round(max_runtime*0.05)
                derivative=load_demand(i-1)+lower_demand*rand;
                if derivative > upper_demand
                    derivative=upper_demand;
                end
                load_demand=[load_demand derivative];
            end
            for i=3*round(max_runtime*0.05)+1:max_runtime
                derivative=load_demand(i-1)-lower_demand*rand;
                if derivative < lower_demand
                    derivative=lower_demand;
                end
                load_demand=[load_demand derivative];
            end
            if savefile(load_demand,'%d ','dat/log/load_demand.txt')<0
                return;
            end
        end
    otherwise
        load_demand(1:max_runtime)=dis_type;
end %switch