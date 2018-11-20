function Num = getNum(handle1, handle2)

Str = get(handle1, 'String');
if strcmp(get(handle2, 'Userdata'), 'OK')
    Dbe = str2double(Str);
    if isempty(Str)
        myerrordlg('The value of the parameter cannot be empty.');
    elseif Dbe == Dbe && Dbe >=0
        Num = Dbe;
        return;
    else
        myerrordlg('The value of the parameter must be positive numbers.');
    end
    twinkle(handle1);
    set(handle2, 'Userdata', 'WRONG');
end
Num = [];