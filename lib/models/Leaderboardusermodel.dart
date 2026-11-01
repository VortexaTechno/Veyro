
import 'package:ahlachat/models/AgencyModel.dart';
import 'package:ahlachat/models/FamilyModel.dart';
import 'package:ahlachat/models/Usermodel.dart';

// ================= USER LEADERBOARD =================

class Leaderboardusermodel {
  String? coins;
  int? userId;
  usermodel? user;

  Leaderboardusermodel({this.coins, this.userId, this.user});

  Leaderboardusermodel.fromJson(Map<String, dynamic> json) {
    coins = json['coins']?.toString();

    userId = int.tryParse(json['user_id']?.toString() ?? '');

    if (json['user'] != null) {
      user = usermodel.fromJson(
        Map<String, dynamic>.from(json['user']),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['coins'] = coins;
    data['user_id'] = userId;

    if (user != null) {
      data['user'] = user!.toJson();
    }

    return data;
  }
}

// ================= FAMILY LEADERBOARD =================

class LeaderboardFamilymodel {
  String? coins;
  int? userId;
  FamilyModel? Family;

  LeaderboardFamilymodel({this.coins, this.userId, this.Family});

  LeaderboardFamilymodel.fromJson(Map<String, dynamic> json) {
    coins = json['coins']?.toString();

    userId = int.tryParse(json['user_id']?.toString() ?? '');

    if (json['family'] != null) {
      Family = FamilyModel.fromJson(
        Map<String, dynamic>.from(json['family']),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['coins'] = coins;
    data['user_id'] = userId;

    if (Family != null) {
      data['family'] = Family!.toJson();
    }

    return data;
  }
}

// ================= AGENCY LEADERBOARD =================

class LeaderboardAgencymodel {
  String? coins;
  int? agencyid;
  Agencymodel? Agency;

  LeaderboardAgencymodel({this.coins, this.agencyid, this.Agency});

  LeaderboardAgencymodel.fromJson(Map<String, dynamic> json) {
    coins = json['coins']?.toString();

    agencyid = int.tryParse(json['agency_id']?.toString() ?? '');

    if (json['agency'] != null) {
      Agency = Agencymodel.fromJson(
        Map<String, dynamic>.from(json['agency']),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['coins'] = coins;
    data['agency_id'] = agencyid;

    if (Agency != null) {
      data['agency'] = Agency!.toJson();
    }

    return data;
  }
}

// ================= AGENCY CATEGORY =================

class AgencyLeaderBoard {
  List<LeaderboardAgencymodel>? supporter;
  List<LeaderboardAgencymodel>? supported;

  AgencyLeaderBoard({this.supporter, this.supported});

  AgencyLeaderBoard.fromJson(Map<String, dynamic> json) {
    if (json['Supporter'] is List) {
      supporter = (json['Supporter'] as List)
          .map((v) => LeaderboardAgencymodel.fromJson(
        Map<String, dynamic>.from(v),
      ))
          .toList();
    }

    if (json['Supported'] is List) {
      supported = (json['Supported'] as List)
          .map((v) => LeaderboardAgencymodel.fromJson(
        Map<String, dynamic>.from(v),
      ))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (supporter != null) {
      data['Supporter'] = supporter!.map((v) => v.toJson()).toList();
    }

    if (supported != null) {
      data['Supported'] = supported!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

// ================= USER CATEGORY =================

class ListoflEaderboardcategory {
  List<Leaderboardusermodel>? weeklysupporter;
  List<Leaderboardusermodel>? monthlysupporter;
  List<Leaderboardusermodel>? dailysupporter;

  ListoflEaderboardcategory({
    this.weeklysupporter,
    this.monthlysupporter,
    this.dailysupporter,
  });

  ListoflEaderboardcategory.fromJson(Map<String, dynamic> json) {
    if (json['weeklysupporter'] is List) {
      weeklysupporter = (json['weeklysupporter'] as List)
          .map((v) => Leaderboardusermodel.fromJson(
        Map<String, dynamic>.from(v),
      ))
          .toList();
    }

    if (json['Monthlysupporter'] is List) {
      monthlysupporter = (json['Monthlysupporter'] as List)
          .map((v) => Leaderboardusermodel.fromJson(
        Map<String, dynamic>.from(v),
      ))
          .toList();
    }

    if (json['dailysupporter'] is List) {
      dailysupporter = (json['dailysupporter'] as List)
          .map((v) => Leaderboardusermodel.fromJson(
        Map<String, dynamic>.from(v),
      ))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (weeklysupporter != null) {
      data['weeklysupporter'] =
          weeklysupporter!.map((v) => v.toJson()).toList();
    }

    if (monthlysupporter != null) {
      data['Monthlysupporter'] =
          monthlysupporter!.map((v) => v.toJson()).toList();
    }

    if (dailysupporter != null) {
      data['dailysupporter'] =
          dailysupporter!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

// ================= FAMILY CATEGORY =================

class ListoflEaderboardFamilycategory {
  List<LeaderboardFamilymodel>? weeklysupporter;
  List<LeaderboardFamilymodel>? monthlysupporter;
  List<LeaderboardFamilymodel>? dailysupporter;

  ListoflEaderboardFamilycategory({
    this.weeklysupporter,
    this.monthlysupporter,
    this.dailysupporter,
  });

  ListoflEaderboardFamilycategory.fromJson(Map<String, dynamic> json) {
    if (json['weeklyFamily'] is List) {
      weeklysupporter = (json['weeklyFamily'] as List)
          .map((v) => LeaderboardFamilymodel.fromJson(
        Map<String, dynamic>.from(v),
      ))
          .toList();
    }

    if (json['MonthlyFamily'] is List) {
      monthlysupporter = (json['MonthlyFamily'] as List)
          .map((v) => LeaderboardFamilymodel.fromJson(
        Map<String, dynamic>.from(v),
      ))
          .toList();
    }

    if (json['dailyFamily'] is List) {
      dailysupporter = (json['dailyFamily'] as List)
          .map((v) => LeaderboardFamilymodel.fromJson(
        Map<String, dynamic>.from(v),
      ))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (weeklysupporter != null) {
      data['weeklyFamily'] =
          weeklysupporter!.map((v) => v.toJson()).toList();
    }

    if (monthlysupporter != null) {
      data['MonthlyFamily'] =
          monthlysupporter!.map((v) => v.toJson()).toList();
    }

    if (dailysupporter != null) {
      data['dailyFamily'] =
          dailysupporter!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
