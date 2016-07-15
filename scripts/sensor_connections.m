% Functional test for sensor-level connectivity 

[HM, CT, Tr, Ctx] = GenerData(pi/10, 100, 0, 0.35, 0, false);
conInds = GetSensorConnectivity(imag(CT), 0.3);
DrawConnectionsOnSensors(conInds);
