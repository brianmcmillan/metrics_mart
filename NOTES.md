# Notes

## Testing
### Structural
[] Does the database file exist?  
[] Does the database exist?  
[] Does the table exist?  
[] Does the table have the expected schema?  

### Functional
[] Is the data in a column within the expected bounds?  
[] Is the calculation returning the correct value?  

## Metrics
[] Size of database file.  
[] Count of rows per table.  

## Metadata
[] Business contact(s)  
[] Technical contact(s)  
[] Service description  
[] Table description  
[] Column description  
[] ER diagram(s)  
[] Descriptive statistics  


## Minimal data pipeline makefile
[] Initiallize the project and dependencies  

[] Download csv file into svc/load/  
[] Append provider_code, load_dts  
[] Create database + load into SRC_  
[] Deploy locally with datasette  