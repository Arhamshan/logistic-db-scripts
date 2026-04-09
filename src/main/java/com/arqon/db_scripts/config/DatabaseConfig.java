package com.arqon.db_scripts.config;

import liquibase.integration.spring.SpringLiquibase;
import org.springframework.boot.autoconfigure.liquibase.LiquibaseProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import javax.sql.DataSource;

@Configuration
public class DatabaseConfig {

    @Bean
    @Primary
    @ConfigurationProperties(prefix = "spring.datasource.logistic-db")
        public DataSource logisticDbDataSource() {
        return DataSourceBuilder.create().build();
    }
	
    @Bean
    @ConfigurationProperties(prefix = "spring.datasource.logistic-db.liquibase")
    public LiquibaseProperties logisticDbLiquibaseProperties() {
        return new LiquibaseProperties();
    }

    @Bean("liquibase")
    public SpringLiquibase logisticDbbLiquibase() {
        return springLiquibase(logisticDbDataSource(), logisticDbLiquibaseProperties());
    }

	
    private static SpringLiquibase springLiquibase(DataSource dataSource, LiquibaseProperties properties) {
        SpringLiquibase liquibase = new SpringLiquibase();
        liquibase.setDataSource(dataSource);
        liquibase.setChangeLog(properties.getChangeLog());
        //liquibase.setContexts(properties.getContexts());
        liquibase.setDefaultSchema(properties.getDefaultSchema());
        liquibase.setDropFirst(properties.isDropFirst());
        liquibase.setShouldRun(properties.isEnabled());
        liquibase.setChangeLogParameters(properties.getParameters());
        liquibase.setRollbackFile(properties.getRollbackFile());
        return liquibase;
    }
}
