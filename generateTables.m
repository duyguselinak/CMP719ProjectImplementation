function [TrainTable,blds,ds] = generateTables(train_ann_files,imds)
    
    %FOR ONLY YOLO
    %This function generates all the train tables
    %To use in the training steps
    %Read all annotation files
    %Then seperate the annotation into 8 categories

    NoTrAnn = length(train_ann_files);
    PO1=cell(1,NoTrAnn);
    CO=cell(1,NoTrAnn);
    WA=cell(1,NoTrAnn);
    MP=cell(1,NoTrAnn);
    LA=cell(1,NoTrAnn);
    TA=cell(1,NoTrAnn);
    PO2=cell(1,NoTrAnn);
    NL=cell(1,NoTrAnn);
    cnt = 0;
    for j=1:NoTrAnn
        a = readtable(train_ann_files(j).name);
        for i = 1:size(a,1)
           if a.Var2{i} == "PO1"
                PO1{j} = [a.Var3(i),a.Var4(i),a.Var5(i),a.Var6(i)];
           elseif a.Var2{i} == "CO"
                CO{j} = [a.Var3(i),a.Var4(i),a.Var5(i),a.Var6(i)];
           elseif a.Var2{i} == "WA"
                WA{j} = [a.Var3(i),a.Var4(i),a.Var5(i),a.Var6(i)];
           elseif  a.Var2{i} == "MP"
                MP{j} = [a.Var3(i),a.Var4(i),a.Var5(i),a.Var6(i)];
           elseif a.Var2{i} == "LA"
                LA{j} = [a.Var3(i),a.Var4(i),a.Var5(i),a.Var6(i)];
           elseif a.Var2{i} == "TA"
                TA{j} = [a.Var3(i),a.Var4(i),a.Var5(i),a.Var6(i)];
           elseif a.Var2{i} == "PO2"
                PO2{j} = [a.Var3(i),a.Var4(i),a.Var5(i),a.Var6(i)];
           elseif a.Var2{i} == "NL"
                cnt = cnt + 1;
                NL{j} = [a.Var3(i),a.Var4(i),a.Var5(i),a.Var6(i)];
           end
        end
    end
    pause(2);
    disp(cnt);
    TrainTable = table(imds.Files, PO1', PO2', WA', LA', MP', TA', CO', NL');
    TrainTable.Properties.VariableNames = ["FileName", "PO1", "PO2", "WA", "LA", "MP", "TA", "CO", "NL"];
    
    %TableCorrection
    [r,c] = size(TrainTable);
    for i=1:r
        if ~isempty(TrainTable.PO1{i})
            temp = TrainTable.PO1{i};
            for k=1:4
                if temp(k)<0
                    temp(k) = temp(k)*(-1);
                end
            end
            temp(3) =  temp(3) -  temp(1);
            temp(4) =  temp(4) -  temp(2);
            TrainTable.PO1{i} = temp;
        end

        if ~isempty(TrainTable.PO2{i})
            temp = TrainTable.PO2{i};
            for k=1:4
                if temp(k)<0
                    temp(k) = temp(k)*(-1);
                end
            end
            temp(3) =  temp(3) -  temp(1);
            temp(4) =  temp(4) -  temp(2);
            TrainTable.PO2{i} = temp;
        end

        if ~isempty(TrainTable.WA{i})
            temp = TrainTable.WA{i};
            for k=1:4
                if temp(k)<0
                    temp(k) = temp(k)*(-1);
                end
            end
            temp(3) =  temp(3) -  temp(1);
            temp(4) =  temp(4) -  temp(2);
            TrainTable.WA{i} = temp;
        end

        if ~isempty(TrainTable.LA{i})
            temp = TrainTable.LA{i};
            for k=1:4
                if temp(k)<0
                    temp(k) = temp(k)*(-1);
                end
            end
            temp(3) =  temp(3) -  temp(1);
            temp(4) =  temp(4) -  temp(2);
            TrainTable.LA{i} = temp;
        end

        if ~isempty(TrainTable.MP{i})
            temp = TrainTable.MP{i};
            for k=1:4
                if temp(k)<0
                    temp(k) = temp(k)*(-1);
                end
            end
            temp(3) =  temp(3) -  temp(1);
            temp(4) =  temp(4) -  temp(2);
            TrainTable.MP{i} = temp;
        end

        if ~isempty(TrainTable.TA{i})
            temp = TrainTable.TA{i};
            for k=1:4
                if temp(k)<0
                    temp(k) = temp(k)*(-1);
                end
            end
            temp(3) =  temp(3) -  temp(1);
            temp(4) =  temp(4) -  temp(2);
            TrainTable.TA{i} = temp;
        end

        if ~isempty(TrainTable.CO{i})
            temp = TrainTable.CO{i};
            for k=1:4
                if temp(k)<0
                    temp(k) = temp(k)*(-1);
                end
            end
            temp(3) =  temp(3) -  temp(1);
            temp(4) =  temp(4) -  temp(2);
            TrainTable.CO{i} = temp;
        end

        if ~isempty(TrainTable.NL{i})
            temp = TrainTable.NL{i};
            for k=1:4
                if temp(k)<0
                    temp(k) = temp(k)*(-1);
                end
            end
            temp(3) =  temp(3) -  temp(1);
            temp(4) =  temp(4) -  temp(2);
            TrainTable.NL{i} = temp;
        end


       if isempty(TrainTable.PO1{i})
           TrainTable.PO1{i} = [1 1 1 1];
       end
       if isempty(TrainTable.PO2{i})
           TrainTable.PO2{i} = [1 1 1 1];
       end
       if isempty(TrainTable.CO{i})
           TrainTable.CO{i} = [1 1 1 1];
       end
       if isempty(TrainTable.MP{i})
           TrainTable.MP{i} = [1 1 1 1];
       end
       if isempty(TrainTable.TA{i})
           TrainTable.TA{i} = [1 1 1 1];
       end
       if isempty(TrainTable.WA{i})
           TrainTable.WA{i} = [1 1 1 1];
       end
       if isempty(TrainTable.LA{i})
           TrainTable.LA{i} = [1 1 1 1];
       end
       if isempty(TrainTable.NL{i})
           TrainTable.NL{i} = [1 1 1 1];
       end
    end

     blds = boxLabelDatastore(TrainTable(:,2:end));
     ds = combine(imds,blds);
 end