clear all;
clc;

txtfiles = dir('*.txt');
NoTxt = length(txtfiles);

%This Script read all annoation files
%Try to find the category names in Chinese
%Then change them to English
%Then save all new txt files to a new file

tic;
for k=1:NoTxt
    a = readtable(txtfiles(k).name);
    for i=1:size(a,1)
       if a.Var2{i} == "不带电芯充电宝"
%             disp('PO1');
             a.Var2{i} = 'PO1';
       elseif a.Var2{i} == "绿色液体"
%            disp('CO');
            a.Var2{i} = 'CO';
       elseif a.Var2{i} == "蓝色液体"
%            disp('WA');
            a.Var2{i} = 'WA';
       elseif  a.Var2{i} == "手机"
%            disp('MP');
              a.Var2{i} = 'MP';
       elseif a.Var2{i} == "电脑"
%            disp('LA');
            a.Var2{i} = 'LA';
       elseif a.Var2{i} == "平板电脑"
%            disp('TA');
            a.Var2{i} = 'TA';
       elseif a.Var2{i} == "带电芯充电宝"
%            disp('PO2');
            a.Var2{i} = 'PO2';
       elseif a.Var2{i} == "非金属打火机"
           a.Var2{i} = 'NL';
       end
    end
    writetable(a, "test_en\" + txtfiles(k).name, 'Delimiter',' ', 'WriteVariableNames', false);
end
time = toc;



