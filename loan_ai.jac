walker smart_ai {
    has customer;
    
    can analyze with entry {
        score = customer.credit;
        stability = std.min(customer.employment, 10);
        affordability = customer.loan / customer.income;
        
        risk = (1 - score/1000) * affordability * (1 - stability/10);
        
        if (risk < 0.2) { decision = "APPROVE"; }
        elif (risk < 0.5) { decision = "REVIEW"; }
        else { decision = "REJECT"; }
        
        confidence = 1 - risk;
        std.out("AI Result: " + customer.name + ": " + decision);
        std.out("Risk: " + risk.str() + " | Confidence: " + confidence.str());
    }
}

with entry {
    applicants = [
        {"name":"Alice","credit":780,"income":90000,"loan":15000,"employment":5},
        {"name":"Bob","credit":580,"income":35000,"loan":20000,"employment":1}
    ];
    for person in applicants {
        spawn here walker::smart_ai(customer=person);
    }
}