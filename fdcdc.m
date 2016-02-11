function res=fdcdc(vin, vout, alpha,ratio,dist_type)
switch (dist_type)
    case 'uni'
        res=unifcdf(vin,ratio*vout,vout)-alpha;
    case 'exp'
        res=expcdf(vin,300)-alpha;
end