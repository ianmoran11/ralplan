
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ralplan

``` r
put_on_wash1 <- T(name = "Put on wash 1", time = duration("15 minutes"), priority = 10, resources = list(washing_machine = 1))
put_on_wash2 <- T(name = "put on wash 2", time = duration("15 minutes"), priority = 10, resources = list(washing_machine = 1))
wash1        <- T(name = "Wash 1", time = duration("120 minutes"), priority = 10, resources = list(washing_machine = 1))
wash2        <- T(name = "Wash 2", time = duration("120 minutes"), priority = 10, resources = list(washing_machine = 1))
hang_clothes <- T(name = "Hang clothes", time = duration("15 minutes"), priority = 10, resources = list(cook = 1))
fold_clothes <- T(name = "Fold clothes", time = duration("30 minutes"), priority = 10, resources = list(cook = 1))
iron         <- T(name = "Iron", time = duration("30 minutes"), priority = 10, resources = list(cook = 1))
grocery_shop <- T(name = "Grocery shop", time = duration("15 minutes"), priority = 10, resources = list(cook = 1))
sweep_floors <- T(name = "Sweep floors", time = duration("30 minutes"), priority = 10, resources = list(cook = 1))
mop          <- T(name = "Mop", time = duration("20 minutes"), priority = 10, resources = list(cook = 1))
vacuum       <- T(name = "Vacuum", time = duration("30 minutes"), priority = 10, resources = list(cook = 1))
dry_clothes  <- T(name = "Dry clothes", time = duration("6 hours"), priority = 10, resources = list(rack = 1))
dry_clothes_dryer  <- T(name = "Dry clothes dryer", time = duration("2 hours"), priority = 10, resources = list(dryer = 1))
```

``` r
plan <- 
  fold_clothes(after(dry_clothes_dryer)) + 
  iron(after(dry_clothes)) + 
  dry_clothes(after(hang_clothes)) + 
  hang_clothes(after(wash2)) +
  dry_clothes_dryer(after(wash2)) +
  wash2(after(put_on_wash2)) + 
  put_on_wash2(after(wash1)) +
  wash1(after(put_on_wash1)) + 
  vacuum(after(mop)) +
  mop(after(sweep_floors))
```

``` r
result <- 
  execute( 
    plan, 
    resource_pool = list(cook = 1, washing_machine = 1, dryer = 1, rack =1),
    timeslots = create_work_times(n = 4*24,15)
  )

plot_executed_plan(result)
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />
