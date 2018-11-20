function infoText(infoStr)

try
    global hInfoText;
    InfoHistory = get(hInfoText, 'String');
    if ischar(InfoHistory)
        InfoHistory = {InfoHistory};
    end
    info = [infoStr, ' (', datestr(now, 13), ')'];
    set(hInfoText, 'String', [InfoHistory; info]);
end