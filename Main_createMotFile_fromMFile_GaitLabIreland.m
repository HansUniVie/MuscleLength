%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hans.kainz@univie.ac.at
% September 2020
% this code creates .mot files with joint angles stored in a c3d file (e.g.
% joint angles from the conventional gait model)
% the .mot file can be used in OpenSim to calculate muscle-tendon length 
% please cite following paper when using this code:
% Kainz and Schwartz (2021) The importance of a consistent workflow to estimate muscle-tendon lengths based on
% joint angles from the conventional gait model. Gait & Posture.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clc; close all;
% add btk folder to path
folder = [pwd '\BTK'];
addpath(genpath(folder));
% define reference OpenSim model
model_ref = 'gait2392_PiGpelvisFrame3DoFkneeNoTorso.osim';
% define relevant angles in OpenSim model for the right leg (change if you use a different model)
angleSet_OpenSim_Model = {'hip_flexion_r' 'hip_adduction_r' 'hip_rotation_r' 'knee_flexion_r' 'knee_adduction_r' 'knee_rotation_r' 'ankle_angle_r' 'subtalar_angle_r'};
% define correspnding angles from c3d file (change is the names are different in your
% files)
angleSet_Clinical_Model = {'RHip' 'RKnee' 'RAnkle'};
% load m file
            mfileData = load('DataIreland.mat')
            time(1,1) = 0;
                for t = 2 : length(mfileData.EA.JointAngle.RHip.Data)
                    time(t,1) = time(t-1,1) + (1/mfileData.EA.JointAngle.RHip.Rate);    
                end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%% get model coordinates from OpenSim reference model
% hardcoded for gait lab in Ireland
   ModelCoordinates = ["pelvis_tilt";"pelvis_list";"pelvis_rotation";"pelvis_tx";"pelvis_ty";"pelvis_tz";"hip_flexion_r";"hip_adduction_r";"hip_rotation_r";"knee_flexion_r";"knee_adduction_r";"knee_rotation_r";"ankle_angle_r";"subtalar_angle_r";"mtp_angle_r";"hip_flexion_l";"hip_adduction_l";"hip_rotation_l";"knee_flexion_l";"knee_adduction_l";"knee_rotation_l";"ankle_angle_l";"subtalar_angle_l";"mtp_angle_l"]
%             import org.opensim.modeling.*;
%             model = Model(model_ref);
%             num = model.getNumCoordinates();            
%             cordSet= model.getCoordinateSet();
%             for n = 0:(num-1)
%                 Coord_model = cordSet().get(n);
%                 JavaString = Coord_model.getName();
%                 nn=n+1;
%                 ModelCoordinates(nn,1) = string(JavaString);
%                 clear Coord_model; clear JavaString;
%             end
            
         %% create empty mot file   
            motfile.time = time;
            f = length(motfile.time); % frames
            for cord = 1:length(ModelCoordinates) % add all coordinates to file with a value of zero     
                motfile.(ModelCoordinates(cord))(1:f,1) = 0;                
            end
%% add hip, knee and ankle kinematics from the c3d file to the .mot file
%% change order here if needed
uptCoord_order = {'2' '1' '3' '2' '1' '3' '2' '1' '3' '2' '1' '3' '2' '1' '3'};

            for updCord = 1:length(angleSet_OpenSim_Model)
                if updCord < 4
                CGMnum = 1;
                motfile.(char(angleSet_OpenSim_Model(updCord))) = mfileData.EA.JointAngle.(char(angleSet_Clinical_Model(CGMnum))).Data(:,(str2num(uptCoord_order{updCord})));
                else
                    if updCord < 7
                    CGMnum = 2;
                    updCord2 = updCord - 3;
                    motfile.(char(angleSet_OpenSim_Model(updCord))) = mfileData.EA.JointAngle.(char(angleSet_Clinical_Model(CGMnum))).Data(:,(str2num(uptCoord_order{updCord})));
                    else
                        if updCord == 7
                        CGMnum = 3;
                        updCord2 = 1;
                        motfile.(char(angleSet_OpenSim_Model(updCord))) = mfileData.EA.JointAngle.(char(angleSet_Clinical_Model(CGMnum))).Data(:,(str2num(uptCoord_order{updCord})));
                        else
                            if updCord == 8
                            CGMnum = 3;
                            updCord2 = 3;
                            motfile.(char(angleSet_OpenSim_Model(updCord))) = mfileData.EA.JointAngle.(char(angleSet_Clinical_Model(CGMnum))).Data(:,(str2num(uptCoord_order{updCord})));
                            else
                            end
                        end
                    end
                end                     
            end
 %% same for left leg
        % change name to left side
        for a = 1:length(angleSet_OpenSim_Model)
            angleSet_OpenSim_Model{1,a} = ([angleSet_OpenSim_Model{1,a}(1:end-1) 'l']); 
        end
        for a = 1:length(angleSet_Clinical_Model)
            angleSet_Clinical_Model{1,a} = (['L' angleSet_Clinical_Model{1,a}(2:end)]); 
        end
       % add hip, knee and ankle kinematics from the c3d file to the .mot file
            for updCord = 1:length(angleSet_OpenSim_Model)
                if updCord < 4
                CGMnum = 1;
                motfile.(char(angleSet_OpenSim_Model(updCord))) = mfileData.EA.JointAngle.(char(angleSet_Clinical_Model(CGMnum))).Data(:,(str2num(uptCoord_order{updCord})));
                else
                    if updCord < 7
                    CGMnum = 2;
                    updCord2 = updCord - 3;
                    motfile.(char(angleSet_OpenSim_Model(updCord))) = mfileData.EA.JointAngle.(char(angleSet_Clinical_Model(CGMnum))).Data(:,(str2num(uptCoord_order{updCord})));
                    else
                        if updCord == 7
                        CGMnum = 3;
                        updCord2 = 1;
                        motfile.(char(angleSet_OpenSim_Model(updCord))) = mfileData.EA.JointAngle.(char(angleSet_Clinical_Model(CGMnum))).Data(:,(str2num(uptCoord_order{updCord})));
                        else
                            if updCord == 8
                            CGMnum = 3;
                            updCord2 = 3;
                            motfile.(char(angleSet_OpenSim_Model(updCord))) = mfileData.EA.JointAngle.(char(angleSet_Clinical_Model(CGMnum))).Data(:,(str2num(uptCoord_order{updCord})));
                            else
                            end
                        end
                    end
                end                     
            end
%% create and save motion (.mot) file
            MotFileName =  'TestIreland.mot';
            MotFileName(MotFileName == ' ') = ['_']; % replace space by '_'
            write_sto_file(motfile, MotFileName);      

