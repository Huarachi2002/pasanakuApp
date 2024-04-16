class Invitaciones {
    Meta meta;
    List<Datum> data;

    Invitaciones({
        required this.meta,
        required this.data,
    });

}

class Datum {
    int id;
    String phone;
    String email;
    DateTime createdAt;
    DateTime updatedAt;
    int gameId;
    String playerId;
    Game game;
    Player player;

    Datum({
        required this.id,
        required this.phone,
        required this.email,
        required this.createdAt,
        required this.updatedAt,
        required this.gameId,
        required this.playerId,
        required this.game,
        required this.player,
    });

}

class Game {
    int id;
    String name;
    int numberOfPlayers;
    int cuota;
    String estado;
    dynamic pathImage;
    String description;
    DateTime startDate;
    DateTime createdAt;
    DateTime updatedAt;
    int periodId;
    Period period;

    Game({
        required this.id,
        required this.name,
        required this.numberOfPlayers,
        required this.cuota,
        required this.estado,
        required this.pathImage,
        required this.description,
        required this.startDate,
        required this.createdAt,
        required this.updatedAt,
        required this.periodId,
        required this.period,
    });

}

class Period {
    int id;
    String name;
    DateTime createdAt;
    DateTime updatedAt;

    Period({
        required this.id,
        required this.name,
        required this.createdAt,
        required this.updatedAt,
    });

}

class Player {
    String id;
    String email;
    String name;
    dynamic sexo;
    String ci;
    String telephone;
    String address;
    String password;
    dynamic pathImage;
    DateTime createdAt;
    DateTime updatedAt;

    Player({
        required this.id,
        required this.email,
        required this.name,
        required this.sexo,
        required this.ci,
        required this.telephone,
        required this.address,
        required this.password,
        required this.pathImage,
        required this.createdAt,
        required this.updatedAt,
    });

}

class Meta {
    int code;
    String message;

    Meta({
        required this.code,
        required this.message,
    });

}
