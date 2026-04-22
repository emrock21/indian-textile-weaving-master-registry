// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

contract IndianTextileWeavingMasterRegistry {

    struct WeavingStyle {
        string region;               // Uttar Pradesh, Tamil Nadu, Gujarat, etc.
        string lineageOrWorkshop;    // Ansari weavers, Salvi family, Kanchipuram clusters, etc.
        string styleName;            // Banarasi, Kanchipuram, Patola, Jamdani, etc.
        string materials;            // silk, cotton, zari, natural dyes
        string weavingTechnique;     // brocade, ikat, jamdani, extra weft, pit loom, etc.
        string motifs;               // butidar, mango, geometric, temple borders
        string uniqueness;           // what makes this weaving school culturally distinct
        address creator;
        uint256 likes;
        uint256 dislikes;
        uint256 createdAt;
    }

    struct StyleInput {
        string region;
        string lineageOrWorkshop;
        string styleName;
        string materials;
        string weavingTechnique;
        string motifs;
        string uniqueness;
    }

    WeavingStyle[] public styles;

    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event StyleRecorded(
        uint256 indexed id,
        string styleName,
        string lineageOrWorkshop,
        address indexed creator
    );

    event StyleVoted(
        uint256 indexed id,
        bool like,
        uint256 likes,
        uint256 dislikes
    );

    constructor() {
        styles.push(
            WeavingStyle({
                region: "India",
                lineageOrWorkshop: "ExampleWorkshop",
                styleName: "Example Style (replace with real entries)",
                materials: "example materials",
                weavingTechnique: "example technique",
                motifs: "example motifs",
                uniqueness: "example uniqueness",
                creator: address(0),
                likes: 0,
                dislikes: 0,
                createdAt: block.timestamp
            })
        );
    }

    function recordStyle(StyleInput calldata s) external {
        styles.push(
            WeavingStyle({
                region: s.region,
                lineageOrWorkshop: s.lineageOrWorkshop,
                styleName: s.styleName,
                materials: s.materials,
                weavingTechnique: s.weavingTechnique,
                motifs: s.motifs,
                uniqueness: s.uniqueness,
                creator: msg.sender,
                likes: 0,
                dislikes: 0,
                createdAt: block.timestamp
            })
        );

        emit StyleRecorded(
            styles.length - 1,
            s.styleName,
            s.lineageOrWorkshop,
            msg.sender
        );
    }

    function voteStyle(uint256 id, bool like) external {
        require(id < styles.length, "Invalid ID");
        require(!hasVoted[id][msg.sender], "Already voted");

        hasVoted[id][msg.sender] = true;

        WeavingStyle storage w = styles[id];

        if (like) {
            w.likes += 1;
        } else {
            w.dislikes += 1;
        }

        emit StyleVoted(id, like, w.likes, w.dislikes);
    }

    function totalStyles() external view returns (uint256) {
        return styles.length;
    }
}
