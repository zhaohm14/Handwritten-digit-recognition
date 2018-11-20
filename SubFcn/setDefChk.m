function setDefChk(handle, struct, variable, fcn, hObject, eventdata, handles, struct2)

NumArgIn = nargin;
Do = 0;
if isfield(struct, variable)
    Chk = eval(['struct.' , variable]);
    Do = 1;
elseif NumArgIn == 8
    if isfield(struct2, variable)
        Chk = eval(['struct2.' , variable]);
        Do = 1;
    end
end

if Do
    if Chk && ~get(handle, 'Value')
        set(handle, 'Value', 1);
    end
    if NumArgIn >= 7
        fcn(hObject, eventdata, handles);
    end
end