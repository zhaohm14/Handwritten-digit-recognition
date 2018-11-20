function setDefNum(handle, struct, variable, def, struct2, variable2)

NumArgIn = nargin;
if isfield(struct, variable)
    set(handle, 'String', num2str(eval(['struct.' , variable])));
    return;
elseif NumArgIn == 5
    if isfield(struct2, variable)
        set(handle, 'String', num2str(eval(['struct2.' , variable])));
        return;
    end
elseif NumArgIn ==6
    if isfield(struct2, variable2)
        set(handle, 'String', num2str(eval(['struct2.', variable2])));
        return;
    end
end
if NumArgIn > 3
    set(handle, 'String', def);
end