## Landholding details

saving multiple land details

## Forward workflow

    saving new landdetails , increse the counter badge in landlist fab button
    when click save button , save the details to lendperfect
    when clicking on landlist fab icon show bottomsheet with landlist
    when click on land fill the landdetails form with the land details

## Reverse Workflow

    fetching all the landdetails from webservice and showing in landlist fab button
    when clicking on landlist fab icon show bottomsheet with landlist
    when click on land fill the landdetails form with the land details

## Designing State

    SaveState - init , loading , success , failue , update
    List<LandData> Data Class - it has all the field of Landholding form

## Designing Event

    LandDetailsInitEvent
        clas LandDetailsInitEvent extends LandDetailsEvent
        {
            final List<LandData>? landList;
            LandDetailsInitEvent({required this.landList});
        }
    LandDetailsSaveEvent
         clas LandDetailsInitEvent extends LandDetailsEvent
        {
            final LandData? landData;
            LandDetailsInitEvent({required this.landData});
        }
    LandDetailsUpdateEvent
         clas LandDetailsInitEvent extends LandDetailsEvent
        {
            final LandData? landData;
            LandDetailsInitEvent({required this.landData});
        }
