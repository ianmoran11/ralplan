
library(devtools)
library(lubridate)
library(ralget)
library(tidyverse)
library(tidygraph)
library(ralplan)
library(hrbrthemes)
load_all()

reverse_min <- function(x){-min(as.numeric(x))}
A  <- T(name = "A",time =  duration("1 hour"), priority = 1, resources = list(R1 = 1))
B  <- T(name = "B",time =  duration("2 hour"), priority = 1, resources = list(R1 = 1))
C  <- T(name = "C",time =  duration("1 hour"), priority = 1, resources = list(R1 = 1))
D  <- T(name = "D",time =  duration("3 hour"), priority = 1, resources = list(R1 = 1))
E  <- T(name = "E",time =  duration("1 hour"), priority = 1, resources = list(R1 = 1))
F  <- T(name = "F",time =  duration("2 hour"), priority = 1, resources = list(R1 = 1))
G  <- T(name = "G",time =  duration("2 hour"), priority = 1, resources = list(R2 = 1))
H  <- T(name = "H",time =  duration("1 hour"), priority = 1, resources = list(R2 = 1))
I  <- T(name = "I",time =  duration("1.5 hour"), priority = 1, resources = list(R2 = 1))
J  <- T(name = "J",time =  duration("1 hour"), priority = 1, resources = list(R2 = 1))
K  <- T(name = "K",time =  duration("3 hour"), priority = 1, resources = list(R2 = 1))
L  <- T(name = "L",time =  duration("1 hour"), priority = 1, resources = list(R2 = 1))

C(after(B)) %>% pull(.attrs)


plan <- 
 C(after(B)) + 
 B(after(A)) +
 F(after(E)) + 
 E(after(D)) +
 L(after(K)) + 
 K(after(J)) +
 I(after(H)) + 
 H(after(G))

plot(form(plan))

result <- 
  execute( 
    plan, 
    resource_pool = list(R1 = 1, R2 = 1),
    timeslots = create_work_times(n = 4*24,15)
  )

p <- plot_executed_plan(result)
p + ggtitle("Activity Plan", "Ralplan Gantt") 

result <- 
  execute( 
    plan, 
    resource_pool = list(R1 = 2, R2 = 2),
    timeslots = create_work_times(n = 4*24,15)
  )

p <- plot_executed_plan(result)
p + ggtitle("Activity Plan", "Ralplan Gantt") 
