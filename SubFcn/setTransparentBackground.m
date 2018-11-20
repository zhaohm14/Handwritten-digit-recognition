function setTransparentBackground(hBG, hCt)

pos = get(hCt, 'Position');
pic = getframe(hBG, pos);
set(hCt, 'CData', pic.cdata);
figure
image(pic.cdata)