-- TenantsDB IoT Schema
-- IoT/Sensor monitoring application template

CREATE TABLE devices (
    id SERIAL PRIMARY KEY,
    device_id VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(255),
    type VARCHAR(50),
    status VARCHAR(20) DEFAULT 'active',
    last_seen TIMESTAMP,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE sensors (
    id SERIAL PRIMARY KEY,
    device_id INT REFERENCES devices(id),
    sensor_type VARCHAR(50),
    unit VARCHAR(20),
    min_value DECIMAL(10,2),
    max_value DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE readings (
    id SERIAL PRIMARY KEY,
    sensor_id INT REFERENCES sensors(id),
    value DECIMAL(15,4) NOT NULL,
    recorded_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE alerts (
    id SERIAL PRIMARY KEY,
    sensor_id INT REFERENCES sensors(id),
    alert_type VARCHAR(50),
    message TEXT,
    acknowledged BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_sensors_device ON sensors(device_id);
CREATE INDEX idx_readings_sensor ON readings(sensor_id);
CREATE INDEX idx_readings_time ON readings(recorded_at);
CREATE INDEX idx_alerts_unack ON alerts(acknowledged) WHERE acknowledged = FALSE;