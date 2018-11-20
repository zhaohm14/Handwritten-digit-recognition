function twinkle(handle, times, interval)

NumArgIn = nargin;
if NumArgIn < 2
    times = 3;
    interval = 0.2;
elseif NumArgIn < 3
    interval = 0.2;
end

for ii = 1 : times
    set(handle, 'Visible', 'off');
    pause(interval / 2);
    set(handle, 'Visible', 'on');
    pause(interval / 2);
end