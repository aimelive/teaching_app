class School {
  String name;
  String image;

  School({required this.name, required this.image});

  static List<School> schools = [
    School(
      name: "Ecole Secondaire Marie Adelaide",
      image:
          "https://cdn.pixabay.com/photo/2015/08/05/13/55/children-876543_1280.jpg",
    ),
    School(
      name: "G.S Indangamirwa",
      image:
          "https://cdn.pixabay.com/photo/2020/11/19/08/03/college-5757815_1280.jpg",
    ),
    School(
      name: "Green Hills Academy",
      image:
          "https://cdn.pixabay.com/photo/2022/07/23/07/21/children-7339441_1280.jpg",
    ),
  ];
}
