function sorted_mics = statistic_mic_reshef(x, ys, ex)
    f = fopen('data.csv', 'w');
    Z = [x, ys];
    for n=1:size(Z,2)
        fprintf(f, 'var_%d', n-1);
        for m=1:size(Z,1)
            fprintf(f, ',%f', Z(m,n));
        end
        fprintf(f, '\n');
    end
    fclose(f);
    
    if exist('ex', 'var')
        [status, result] = system(sprintf('java -jar MINE.jar data.csv 0 notify=1 exp=%0.1f',ex));
        file_name = sprintf('data.csv,mv=0,cv=0.0,B=n^%0.1f,Results.csv', ex);
    else
        [status, result] = system('java -jar MINE.jar data.csv 0 notify=1 exp=0.6');
        file_name = 'data.csv,mv=0,cv=0.0,B=n^0.6,Results.csv';
    end
        
    f = fopen(file_name);
    C = textscan(f,'var_%n,var_%n,%f,%s', 'headerlines', 1);
    fclose(f);

    x_num = C{1};
    y_num = C{2};
    mics = C{3};
    
    % Check for glitch
    if max(y_num(:)) > numel(mics)
        sorted_mics = [];
    else
        sorted_mics = mics(y_num);
    end
end