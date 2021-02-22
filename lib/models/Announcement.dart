import 'dart:convert';

Announcement announcementFromJson(String str) => Announcement.fromJson(json.decode(str));

String announcementToJson(Announcement data) => json.encode(data.toJson());

class Announcement {
    Announcement({
        this.id,
        this.title,
        this.description,
        this.status,
    });

    int id;
    String title;
    String description;
    int status;

    factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "status": status,
    };
}
