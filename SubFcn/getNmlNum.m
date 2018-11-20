function NmlNum = getNmlNum(handle1, handle2)

Num = getNum(handle1, handle2);
if strcmp(get(handle2, 'Userdata'), 'OK')
    if Num >= 0 && Num <= 1
        NmlNum = Num;
        return;
    end
    mywarndlg('The value needs to be in the range of 0~1!');
    twinkle(handle1);
    set(handle2, 'Userdata', 'WRONG');
end
NmlNum = [];