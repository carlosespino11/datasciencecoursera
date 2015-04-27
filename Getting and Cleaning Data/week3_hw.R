library(dplyr)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "housing.csv", method = "curl")
data = read.csv("housing.csv")

data = data %>% mutate(agricultureLogical = (ACR ==3 & AGS==6))
which(data$agricultureLogical)



library(jpeg)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg", "image.jpg", method = "curl")
img = readJPEG("image.jpg", native=TRUE)
img
quantile(img, c(.3,.8))

### 3
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", "gdp.csv", method = "curl")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", "education.csv", method = "curl")

gdp = read.csv("gdp.csv", na.strings=c(""), skip = 5, header = F)
gdp = gdp[,colSums(is.na(gdp)) != nrow(gdp)] %>% select(V1:V5) %>% na.omit()
names(gdp) = c("ShortCode", "ranking", "country", "gdp")
gdp = gdp%>% mutate( gdp = as.numeric(sapply(sapply(gdp, function(x){gsub(",", "", as.character(x))}), function(x) { gsub(" ", "", x)})),
                     ranking = as.numeric(as.character(ranking)))
education = read.csv("education.csv", na.strings="")

data = inner_join(gdp, education, c("ShortCode" = "CountryCode"))
data = data %>%arrange(desc(ranking))
data[1:15,] %>% select(Short.Name,ranking) 

data %>% group_by(Income.Group) %>% dplyr::summarise(mean = mean(ranking))

br = quantile(data$ranking,seq(0, 100, 20)/100)

nd = data %>% mutate(mygroup = cut(ranking, breaks=br))
