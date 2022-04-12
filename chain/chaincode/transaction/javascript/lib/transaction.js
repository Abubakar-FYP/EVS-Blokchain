/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */


'use strict';

const {Contract} = require('fabric-contract-api');

class Transaction extends Contract {

    async initLedger(ctx) {
        const PakVotingSystem = [
            {
                sid: 'S01',
                name: 'votes',
                loc : 'Pak'
            }, {
                sid: 'S02',
                name: 'votes',
                loc : 'Pak'
            }
        ];

        for (let i = 0; i < PakVotingSystem.length; i++) {
            await ctx.stub.putState('Assets' + i, Buffer.from(JSON.stringify(PakVotingSystem[i])));
            console.info('Added <--> ', PakVotingSystem[i]);
        }
    }
/**
 * 
 * @param {*} ctx 
 * @param {*} voterId 
 * @param {*} candidateId 
 * @param {*} timestamp 
 */
    async castElectionVote(ctx, voterId, candidateId, timestamp) {
        const transaction = {
            voterId ,
            docType: 'castElectionVote',
            organization : 'PakVotingSystem',
            candidateId,
            timestamp
        };
        await ctx.stub.putState(voterId, Buffer.from(JSON.stringify(transaction)));
    }

/**
 * 
 * @param {*} ctx 
 * @param {*} voterId 
 * @param {*} pollItemid 
 * @param {*} pollId 
 * @param {*} timestamp 
 */
 async castPollVote(ctx, voterId, pollItemid, pollId, timestamp) {
    const transaction = {
        voterId ,
        docType: 'castPollVote',
        organization : 'PakVotingSystem',
        pollItemid,
        pollId,
        timestamp,
    };
    await ctx.stub.putState(voterId, Buffer.from(JSON.stringify(transaction)));
    await ctx.stub.getTxID(transaction);
  
}

    /* Query Assets. */
      async queryAssets(ctx) {
        const startKey = '';
        const endKey = '';
        const allResults = [];
        for await(const {key, value}
        of ctx.stub.getStateByRange(startKey, endKey)) {
            const strValue = Buffer.from(value).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push({Key: key, Record: record});
        }
    
    console.info(allResults);
    return JSON.stringify(allResults);
   
    }
}

module.exports = Transaction;