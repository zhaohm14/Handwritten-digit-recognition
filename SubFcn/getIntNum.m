function IntNum = getIntNum(handle1, handle2)

Num = getNum(handle1, handle2);
if strcmp(get(handle2, 'Userdata'), 'OK')
    if mod(Num, 1) == 0 || Num == Inf
        IntNum = Num;
        return;
    end
    mywarndlg('The value needs to be an integer!');
    twinkle(handle1);
    set(handle2, 'Userdata', 'WRONG');
end
IntNum = [];