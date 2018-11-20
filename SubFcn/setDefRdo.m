function setDefRdo(handle1, handle2, variable, value1)

global PrmStg;
if isfield(PrmStg, variable)
    Rdo = eval(['PrmStg.', variable]);
    if ~strcmp(Rdo, value1)
        set(handle1, 'Value', 0);
        set(handle2, 'Value', 1);
        return;
    end
end
set(handle1, 'Value', 1);
set(handle2, 'Value', 0);