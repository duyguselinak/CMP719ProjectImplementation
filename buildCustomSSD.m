function [customSSDNet,detNetworkSource] = buildCustomSSD(traintestOpt)

    if traintestOpt == true
        net = vgg16(); %Use vgg16
        lgraph = layerGraph(net); %get layergraph

        %Remove some part of layers
        idx_f = find(ismember({lgraph.Layers.Name},'pool2'));
        removedLayers = {lgraph.Layers(idx_f+1:end).Name};
        ssdLayerGraph = removeLayers(lgraph,removedLayers);
             
        weightsInitializerValue = 'glorot';
        biasInitializerValue = 'zeros';
        extraLayers = [];
        

        %LIM implemetation to SSD
        %Conv2DLayer - Layer3
        filterSize = 1;
        numFilters = 128;
        numChannels = 128;
        scale = 2;
        conv3_1 = convolution2dLayer(3*filterSize, 2*numFilters,NumChannels=numChannels, ...
            Name="conv3_1", WeightsInitializer = weightsInitializerValue, BiasInitializer = biasInitializerValue);
        conv3_2 = convolution2dLayer(3*filterSize, 2*numFilters,NumChannels=2*numChannels, ...
            Name="conv3_2", WeightsInitializer = weightsInitializerValue, BiasInitializer = biasInitializerValue);
        conv3_3 = convolution2dLayer(3*filterSize, 4*numFilters,NumChannels=4*numChannels, ...
            Name="conv3_3", WeightsInitializer = weightsInitializerValue, BiasInitializer = biasInitializerValue, Padding = iSamePadding(filterSize));
        conv3_4 = convolution2dLayer(3*filterSize, 8*numFilters,NumChannels=8*numChannels, ...
            Name="conv3_4", WeightsInitializer = weightsInitializerValue, BiasInitializer = biasInitializerValue, Padding = iSamePadding(filterSize));
        extraLayers = [extraLayers; conv3_1; conv3_2; conv3_3; conv3_4];

        %Conv2DLayer - Layer4
        conv4_1 = convolution2dLayer(filterSize, 8*numFilters,NumChannels=8*numChannels, ...
            Name="conv4_1", WeightsInitializer = weightsInitializerValue, BiasInitializer = biasInitializerValue);
        conv4_2 = convolution2dLayer(filterSize, 8*numFilters,NumChannels=8*numChannels, ...
            Name="conv4_2", WeightsInitializer = weightsInitializerValue, BiasInitializer = biasInitializerValue);
        conv4_3 = convolution2dLayer(3*filterSize, 8*numFilters,NumChannels=8*numChannels, ...
            Name="conv4_3", WeightsInitializer = weightsInitializerValue, BiasInitializer = biasInitializerValue, Padding = iSamePadding(filterSize));
        extraLayers = [extraLayers; conv4_1; conv4_2; conv4_3];

        %Conv2DLayer - Layer5
        conv5_1 = convolution2dLayer(filterSize, 8*numFilters,NumChannels=8*numChannels, ...
            Name="conv5_1", WeightsInitializer = weightsInitializerValue, BiasInitializer = biasInitializerValue);
        conv5_2 = resize2dLayer('Scale',scale, 'Name','conv5_2'); %Upsampling Layer
        conv5_3 = resize2dLayer('Scale',scale, 'Name','conv5_3'); %Upsampling Layer
        conv5_4 = resize2dLayer('Scale',scale, 'Name','conv5_4'); %Upsampling Layer
        conv5_5 = resize2dLayer('Scale',scale, 'Name','conv5_5'); %Upsampling Layer
        conv5_6 = convolution2dLayer(3*filterSize, numFilters,NumChannels=numChannels, ...
            Name="conv5_6", WeightsInitializer = weightsInitializerValue, BiasInitializer = biasInitializerValue, Padding = iSamePadding(filterSize));
        extraLayers = [extraLayers; conv5_1; conv5_2; conv5_3; conv5_4; conv5_5; conv5_6];
        
        %FullyConectedLayer - Layer6
        fc6 = fullyConnectedLayer(64, "Name","fc6");
        relu_6 = reluLayer(Name = 'relu_6');
        extraLayers = [extraLayers; fc6; relu_6];

        %FullyConectedLayer - Layer7
        fc7 = fullyConnectedLayer(64, "Name","fc7");
        relu_7 = reluLayer(Name = 'relu_7');
        drop_7 = dropoutLayer(0.2, "Name","drop_7");
        extraLayers = [extraLayers; fc7; relu_7; drop_7];
        
        %FullyConectedLayer - Layer8
        fc8 = fullyConnectedLayer(8, "Name","fc8");
        sL  = softmaxLayer('Name','prob');
        cL  = classificationLayer("Name","out","Classes","auto");
        extraLayers = [extraLayers; fc8; sL; cL];

        if ~isempty(extraLayers)
            lastLayerName = ssdLayerGraph.Layers(end).Name;
            ssdLayerGraph = addLayers(ssdLayerGraph, extraLayers);
            ssdLayerGraph = connectLayers(ssdLayerGraph, lastLayerName, extraLayers(1).Name);
        end
        customSSDNet = ssdLayerGraph;
        detNetworkSource = ["relu1_1","relu1_2", "relu2_1"];
    end

end

