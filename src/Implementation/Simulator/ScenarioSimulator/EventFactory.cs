﻿// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System;
using Microsoft.Practices.IoTJourney.Devices.Events;

namespace Microsoft.Practices.IoTJourney.ScenarioSimulator
{
    public static class EventFactory
    {
        public static UpdateTemperatureEvent TempuratureEventFactory(Random random, Device device)
        {
            if (!device.CurrentTempurature.HasValue)
            {
                device.CurrentTempurature = random.Next(25);
            }
            else
            {
                var temperatureChange = random.Next(2) + 1; //Temperature should change by 1 or 2 degrees
                var isTemperatureIncrease = random.Next(2) == 1;

                if (isTemperatureIncrease)
                {
                    device.CurrentTempurature += temperatureChange;
                }
                else
                {
                    device.CurrentTempurature -= temperatureChange;
                }
            }

            return new UpdateTemperatureEvent
            {
                TimeStamp = DateTime.UtcNow.Ticks,
                Tempurature = device.CurrentTempurature.Value,
            };
        }
    }
}