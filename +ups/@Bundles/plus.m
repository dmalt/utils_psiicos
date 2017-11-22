function obj = plus(obj1, obj2)
    if isequaln(obj1.headModel, obj2.headModel) && isequaln(obj1.Ctx, obj2.Ctx)
        obj = obj1;
        obj.conInds = [obj1.conInds(:); obj2.conInds(:)];
        obj.lwidth = [obj1.lwidth, obj2.lwidth];
        obj.m_rad = [obj1.m_rad, obj2.m_rad];
        obj.icol = [obj1.icol, obj2.icol];
        obj.alpha = [obj1.alpha, obj2.alpha];
    else
        error('plus: incompatible objects');
    end
end
