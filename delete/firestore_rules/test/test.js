const assert = require('assert');
const firebase = require('@firebase/testing');

const MY_PROJECT_ID = "missionout";
const myId = "user_abc";
const theirId = "user_xyz";
const editorId = "user_editor";
const myAuth = {uid: myId, email: "abc@gmail.com"};
const editorAuth = {uid: editorId, email: "some_email@gmail.com"};
const myTeam = "team_abc";
const theirTeam = "team_xyz";

function getFirestore(auth) {
    return firebase.initializeTestApp({projectId : MY_PROJECT_ID, auth : auth}).firestore();
}

function getAdminFirestore(){
    return firebase.initializeAdminApp({projectId : MY_PROJECT_ID}).firestore();
}

before(async ()=>{
    await firebase.clearFirestoreData({projectId: MY_PROJECT_ID});
})

describe("MissionOut app", () => {
    it("Understands basic math", ()=>{
        assert.equal(2+2,4)
    });

    it("Can read items in read-only collection", async ()=>{
        const db = getFirestore(null);
        const testDoc = db.collection("teamDomains").doc("domains");
        await firebase.assertSucceeds(testDoc.get());

    });

    it("Can't write items in read-only collection", async ()=>{
        const db = getFirestore(null);
        const testDoc = db.collection("teamDomains").doc("domains");
        await firebase.assertFails(testDoc.set({foo: "bar"}));
    })

      //		User can get,update own self -- Editor can read.update own team
    it("User can write to their own user document", async ()=>{
        const admin = getAdminFirestore();
        await admin.collection("users").doc(myId).set({foo : "bar"});

        const db = getFirestore(myAuth);
        const testDoc = db.collection("users").doc(myId);
        await firebase.assertSucceeds(testDoc.update({foo: "bar"}));

    });

    it("User can't access another user's document", async ()=>{
        const admin = getAdminFirestore();
        await admin.collection("users").doc(theirId).set({foo : "bar"});

        const db = getFirestore(myAuth);
        const testDoc = db.collection("users").doc(theirId);
        await firebase.assertFails(testDoc.get());

    });

    it("User can read own team document", async ()=>{
        const admin = getAdminFirestore();
        await admin.collection("users").doc(myId).set({foo : "bar", teamID: myTeam});
        await admin.collection("teams").doc(myTeam).set({foo : "bar"});

        const db = getFirestore(myAuth);
        const testDoc = db.collection("teams").doc(myTeam);
        await firebase.assertSucceeds(testDoc.get());
    });

    it("User can't read another team document", async ()=>{
        const admin = getAdminFirestore();
        await admin.collection("users").doc(myId).set({foo : "bar", teamID: myTeam});
        await admin.collection("teams").doc(theirTeam).set({foo : "bar"});

        const db = getFirestore(myAuth);
        const testDoc = db.collection("teams").doc(theirTeam);
        await firebase.assertFails(testDoc.get());
    });

    it("Editor can update team information", async ()=>{
        const admin = getAdminFirestore();
        await admin.collection("users").doc(editorId).set({foo : "bar", teamID: myTeam, isEditor: true});
        await admin.collection("teams").doc(myTeam).set({foo : "bar"});

        const db = getFirestore(editorAuth);
        const testDoc = db.collection("teams").doc(myTeam);
        await firebase.assertSucceeds(testDoc.set({foo:"bar"}));
    });

        it("User can read their team missions", async ()=>{
            const db = getFirestore(myAuth);
            const testDoc = db.collection(`teams/${myTeam}/missions/`).doc("someMission");
            await firebase.assertSucceeds(testDoc.get());
        });

        it("User can't read another team missions", async ()=>{
            const db = getFirestore(myAuth);
            const testDoc = db.collection(`teams/${theirTeam}/missions/`).doc("someMission");
            await firebase.assertFails(testDoc.get());
        });

        it("Editor can write their own team's missions", async ()=>{
            const admin = getAdminFirestore();
            await admin.collection("users").doc(editorId).set({foo : "bar", teamID: myTeam, isEditor: true});

            const db = getFirestore(editorAuth);
            const testDoc = db.collection(`teams/${myTeam}/missions/`).doc("someMission");
            await firebase.assertSucceeds(testDoc.set({foo:"bar"}));
        });

        it("Editor can't write to another team's missions", async ()=>{
            const admin = getAdminFirestore();
            await admin.collection("users").doc(editorId).set({foo : "bar", teamID: myTeam, isEditor: true});
            
            const db = getFirestore(editorAuth);
            const testDoc = db.collection(`teams/${theirTeam}/missions/`).doc("someMission");
            await firebase.assertFails(testDoc.set({foo:"bar"}));
        });

      it("User can write their own responses", async ()=>{
        const db = getFirestore(myAuth);
        const testDoc = db.collection(`teams/${myTeam}/missions/somemission/responses`).doc(myId);
        await firebase.assertSucceeds(testDoc.set({foo:"bar"}));
    });

    it("User can't write to another team's responses", async ()=>{
        const db = getFirestore(myAuth);
        const testDoc = db.collection(`teams/${theirTeam}/missions/somemission/responses`).doc(myId);
        await firebase.assertFails(testDoc.set({foo:"bar"}));
    });
    
      it("Editor can write pages for their own team", async ()=>{
        const admin = getAdminFirestore();
        await admin.collection("users").doc(editorId).set({foo : "bar", teamID: myTeam, isEditor: true});
        
        const db = getFirestore(editorAuth);
        const testDoc = db.collection(`teams/${myTeam}/missions/somemission/pages`).doc("somePage");
        await firebase.assertSucceeds(testDoc.set({foo:"bar"}));
        });

    it("Editor can't write pages for another team", async ()=>{
        const admin = getAdminFirestore();
        await admin.collection("users").doc(editorId).set({foo : "bar", teamID: myTeam, isEditor: true});
        
        const db = getFirestore(editorAuth);
        const testDoc = db.collection(`teams/${theirTeam}/missions/somemission/pages`).doc("somePage");
        await firebase.assertFails(testDoc.set({foo:"bar"}));
        });

        it("General users can't write pages", async ()=>{
            const admin = getAdminFirestore();
            await admin.collection("users").doc(myId).set({foo : "bar", teamID: myTeam, isEditor: false});
            
            const db = getFirestore(myAuth);
            const testDoc = db.collection(`teams/${myTeam}/missions/somemission/pages`).doc("somePage");
            await firebase.assertFails(testDoc.set({foo:"bar"}));
        });
})

after (async ()=>{
    await firebase.clearFirestoreData({projectId: MY_PROJECT_ID});
})