if min(xlim) < 0 && max(xlim) > 0
    xticks([min(xlim), 0, max(xlim)])
else
    xticks(xlim)
end

if min(ylim) < 0 && max(ylim) > 0
    yticks([min(ylim), 0, max(ylim)])
else
    yticks(ylim)
end

if min(zlim) < 0 && max(zlim) > 0
    zticks([min(zlim), 0, max(zlim)])
else
    zticks(zlim)
end
