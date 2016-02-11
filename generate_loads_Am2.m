function load_demand=generate_loads_Am2(dis_type,lower_demand,upper_demand,max_runtime,maxreC,nomcells,interval)

switch dis_type
    case 'rand'
        load_demand=loadfile('dat/log/load_demand-rand-fig0.txt','%d ', [1 Inf]);
        if isempty(load_demand) | load_demand<0
            load_demand=lower_demand;
            for i=2:max_runtime
                derivative=load_demand(i-1)+round(2*lower_demand*normrnd(0,0.5));
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
            upper_demand=maxreC(1)*23*(round(nomcells*0.5)); %coulomb
            for i=2:round(max_runtime*0.06)
                derivative=load_demand(i-1)+round(0.5*lower_demand*rand);
                if derivative > upper_demand
                    derivative=upper_demand;
                end
                load_demand=[load_demand derivative];
            end
            for i=round(max_runtime*0.06)+1:max_runtime
                derivative=load_demand(i-1)-round(0.5*lower_demand*rand);
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
            upper_demand=maxreC(2)*23*(round(nomcells*0.5));
            for i=2:round(max_runtime*0.04)
                derivative=load_demand(i-1)+round(0.5*lower_demand*rand);
                if derivative > upper_demand
                    derivative=upper_demand;
                end
                load_demand=[load_demand derivative];
            end
            for i=round(max_runtime*0.04)+1:max_runtime
                derivative=load_demand(i-1)-round(0.5*lower_demand*rand);
                if derivative > upper_demand
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
            upper_demand=maxreC(1)*23*(round(nomcells*0.5));
            for i=2:round(max_runtime*0.06)
                derivative=load_demand(i-1)+round(0.5*lower_demand*rand);
                if derivative > upper_demand
                    derivative=upper_demand;
                end
                load_demand=[load_demand derivative];
            end
            for i=round(max_runtime*0.06)+1:2*round(max_runtime*0.06)
                derivative=load_demand(i-1)-round(0.5*lower_demand*rand);
                if derivative < lower_demand
                    derivative=lower_demand;
                end
                load_demand=[load_demand derivative];
            end
            for i=2*round(max_runtime*0.06)+1:3*round(max_runtime*0.06)
                derivative=load_demand(i-1)+round(0.5*lower_demand*rand);
                if derivative > upper_demand
                    derivative=upper_demand;
                end
                load_demand=[load_demand derivative];
            end
            for i=3*round(max_runtime*0.06)+1:max_runtime
                derivative=load_demand(i-1)-round(0.5*lower_demand*rand);
                if derivative < lower_demand
                    derivative=lower_demand;
                end
                load_demand=[load_demand derivative];
            end
            if savefile(load_demand,'%d ','dat/log/load_demand.txt')<0
                return;
            end
        end
    case 'comp1'
        load_demand(1:62)=23;
    case 'comp2'
        load_demand(1:9)=23;
        temp(1:2)=0;
        load_demand=[load_demand temp]; temp=[];
        temp(1:10)=23;
        load_demand=[load_demand temp]; temp=[];
        temp(1:23)=46;
        load_demand=[load_demand temp]; temp=[];
    otherwise
        load_demand(1:max_runtime)=dis_type;
end %switch